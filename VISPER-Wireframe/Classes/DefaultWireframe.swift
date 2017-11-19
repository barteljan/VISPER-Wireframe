//
//  VISPERWireframe.swift
//  Pods-SwiftyVISPER_Example
//
//  Created by bartel on 18.11.17.
//

import Foundation

public enum DefaultWireframeError : Error {
    case noRoutingOptionFoundFor(routePattern: String, parameters: [String : Any])
    case noControllerProviderFoundFor(routePattern: String, option: RoutingOption, parameters: [String : Any])
    case noRoutingPresenterFoundFor(option: RoutingOption)
}


open class DefaultWireframe : Wireframe {
    
    //MARK: internal properties
    
    let router: Router
    var optionProviders: [OptionProviderWrapper] = [OptionProviderWrapper]()
    var routingProviders: [ProviderWrapper] = [ProviderWrapper]()
    var routingObservers: [RoutingObserverWrapper] = [RoutingObserverWrapper]()
    var routingPresenters: [RoutingPresenterWrapper] = [RoutingPresenterWrapper]()
    
    //MARK: Initializer
    public init(router : Router = DefaultRouter()){
        self.router = router
    }
    
    //MARK: route
    
    /// Check if a route pattern matching this url was added to the wireframe.
    /// Be careful, if you don't route to a handler (but to a controller),
    /// it's possible that no ControllerProvider or RoutingOptionProvider for this controller exists.
    ///
    /// - Parameters:
    ///   - url: the url to check for resolution
    ///   - parameters: the parameters (data) given to the controller
    /// - Returns: Can the wireframe find a route for the given url
    open func canRoute(url: URL, parameters: [String : Any]) throws -> Bool {
        
        if let _ = try self.router.route(url: url) {
            return true
        }else {
            return false
        }
        
    }
    
    /// Route to a new route presenting a view controller
    ///
    /// - Parameters:
    ///   - url: the route of the view controller to be presented
    ///   - option: how should your view controller be presented
    ///   - parameters: a dictionary of parameters (data) send to the presented view controller
    ///   - completion: function called when the view controller was presented
    /// - Throws: throws an error when no controller and/or option provider can be found.
    open func route(url: URL, option: RoutingOption?, parameters: [String : Any], completion: @escaping () -> Void) throws {
        
        if let routeResult = try self.router.route(url: url) {
            
            //override the parameters from the routeResult with the given parameters from this function
            var params = routeResult.parameters
            parameters.forEach({ (key,value) in
                params[key] = value
            })
            
            //get the right routing option
            var routingOption : RoutingOption? = option
            for optionProviderWrapper in self.optionProviders {
                routingOption = optionProviderWrapper.optionProvider.option(routePattern: routeResult.routePattern,
                                                                              parameters: params,
                                                                           currentOption: routingOption)
            }
            
            var controller: UIViewController?
            
            for routingProviderWrapper in self.routingProviders {
            
                // call the handler if one is registered
                // function returns true if a handler was called
                // you can return in that case because you have found the highest priorized handler
                if self.callHandlerFor(routePattern: routeResult.routePattern,
                                        parameters: params,
                            routingProviderWrapper: routingProviderWrapper,
                                        completion: completion) {
                    return
                }
                
                //since we don't call a handler, we are now shure that our routing option should not be nil
                guard let routingOption = routingOption else {
                    throw DefaultWireframeError.noRoutingOptionFoundFor(routePattern: routeResult.routePattern, parameters: params)
                }
                
                
                if let viewController = self.getController(wrapper: routingProviderWrapper,
                                                      routePattern: routeResult.routePattern,
                                                            option: routingOption,
                                                        parameters: params) {
                    controller = viewController
                    continue
                }
                
            }
            
            //take care that routing option is not nil
            guard let option = routingOption else {
                throw DefaultWireframeError.noRoutingOptionFoundFor(routePattern: routeResult.routePattern, parameters: params)
            }
            
            //take care that controller is not nil
            guard let viewController = controller else {
                throw DefaultWireframeError.noControllerProviderFoundFor(routePattern: routeResult.routePattern,
                                                                         option: option,
                                                                         parameters: params)
            }
            
            //present controller on a routing presenter and notifiy routing observers
            try self.present(viewController: viewController,
                                routeResult: routeResult,
                                     option: option,
                                     params: params,
                                 completion: completion)
            
        }
        
    }
    
    /// Return the view controller for a given url
    ///
    /// - Parameters:
    ///   - url: url
    ///   - parameters: parameters
    /// - Returns: nil if no controller was found, the found controller otherwise
    open func controller(url: URL, parameters: [String : Any]) throws -> UIViewController? {
        
        if let routeResult = try self.router.route(url: url) {
            
            //override the parameters from the routeResult with the given parameters from this function
            var params = routeResult.parameters
            parameters.forEach({ (key,value) in
                params[key] = value
            })
            
            for routingProviderWrapper in self.routingProviders {
                
                if let viewController = self.getController(wrapper: routingProviderWrapper,
                                                           routePattern: routeResult.routePattern,
                                                           option: DefaultGetControllerRoutingOption(),
                                                           parameters: params) {
                    return viewController
                }
                
            }
        }
        
        return nil
    }
    
    //MARK: Add dependencies
    
    /// Register a route pattern for routing.
    /// You have to register a route pattern to allow the wireframe matching it.
    /// This is done automatically if you are using a ViewFeature from SwiftyVISPER as ControllerProvider.
    ///
    /// - Parameters:
    ///   - pattern: the route pattern to register
    open func addRoutePattern(_ pattern: String) throws{
        try self.router.add(routePattern: pattern)
    }
    
    /// Register a route pattern and a handler
    /// The handler will be called if a route matches your route pattern.
    /// (you dont't have to add your pattern manually in this case)
    /// - Parameters:
    ///   - pattern: The route pattern for calling your handler
    ///   - priority: The priority for calling your handler, higher priorities are called first. (Defaults to 0)
    open func addRoutePattern(_ pattern: String, priority: Int = 0, handler: @escaping ([String : Any]) -> Void) throws {
        
        let handlerWrapper = RouteHandlerWrapper(routePattern: pattern,
                                                 handler: handler)
        
        let providerWrapper = ProviderWrapper(priority: priority,
                                    controllerProvider: nil,
                                        handlerWrapper: handlerWrapper)
        
        self.addRoutingProviderWrapper(wrapper: providerWrapper)
    }
    
    /// Add an instance providing a controller for a route
    ///
    /// - Parameters:
    ///   - controllerProvider: instance providing a controller
    ///   - priority: The priority for calling your provider, higher priorities are called first. (Defaults to 0)
    open func add(controllerProvider: ControllerProvider, priority: Int = 0) {
        let providerWrapper = ProviderWrapper(priority: priority,
                                              controllerProvider: controllerProvider,
                                              handlerWrapper: nil)
        self.addRoutingProviderWrapper(wrapper: providerWrapper)
    }
    
    /// Add an instance providing routing options for a route
    ///
    /// - Parameters:
    ///   - optionProvider: instance providing routing options for a route
    ///   - priority: The priority for calling your provider, higher priorities are called first. (Defaults to 0)
    open func add(optionProvider: RoutingOptionProvider, priority: Int = 0) {
        let wrapper = OptionProviderWrapper(priority: priority, optionProvider: optionProvider)
        self.addOptionProviderWrapper(wrapper: wrapper)
    }
    
    /// Add an instance observing controllers before they are presented
    ///
    /// - Parameters:
    ///   - routingObserver: An instance observing controllers before they are presented
    ///   - priority: The priority for calling your provider, higher priorities are called first. (Defaults to 0)
    ///   - routePattern: The route pattern to call this observer, the observer is called for every route if this pattern is nil
    open func add(routingObserver: RoutingObserver, priority: Int = 0, routePattern: String? = nil) {
        let wrapper = RoutingObserverWrapper(priority: priority, routePattern: routePattern, routingObserver: routingObserver)
        self.addRoutingObserverWrapper(wrapper: wrapper)
    }
    
    /// Add an instance responsible for presenting view controllers.
    /// It will be triggert after the wireframe resolves a route
    ///
    /// - Parameters:
    ///    - routingPresenter: An instance responsible for presenting view controllers
    ///    - priority: The priority for calling your provider, higher priorities are called first. (Defaults to 0)
    open func add(routingPresenter: RoutingPresenter,priority: Int = 0) {
        let wrapper = RoutingPresenterWrapper(priority: priority, routingPresenter: routingPresenter)
        self.addRoutingPresenterWrapper(wrapper: wrapper)
    }
    
    //MARK: some helper structs
    
    struct RouteHandlerWrapper {
        let routePattern : String
        let handler : (([String : Any]) -> Void)
    }
    
    struct ProviderWrapper {
        let priority : Int
        let controllerProvider : ControllerProvider?
        let handlerWrapper : RouteHandlerWrapper?
    }
    
    struct OptionProviderWrapper {
        let priority : Int
        let optionProvider : RoutingOptionProvider
    }
    
    internal struct RoutingObserverWrapper {
        let priority : Int
        let routePattern : String?
        let routingObserver : RoutingObserver
    }
    
    internal struct RoutingPresenterWrapper {
        let priority : Int
        let routingPresenter : RoutingPresenter
    }
    
    //MARK: some helper functions
    
    func addRoutingProviderWrapper(wrapper: ProviderWrapper) {
        self.routingProviders.append(wrapper)
        self.routingProviders.sort { (wrapper1, wrapper2) -> Bool in
            return wrapper1.priority > wrapper2.priority
        }
    }
    
    func addOptionProviderWrapper(wrapper: OptionProviderWrapper) {
        self.optionProviders.append(wrapper)
        self.optionProviders.sort { (wrapper1, wrapper2) -> Bool in
            return wrapper1.priority > wrapper2.priority
        }
    }
    
    func addRoutingObserverWrapper(wrapper: RoutingObserverWrapper) {
        self.routingObservers.append(wrapper)
        self.routingObservers.sort { (wrapper1, wrapper2) -> Bool in
            return wrapper1.priority > wrapper2.priority
        }
    }
    
    func addRoutingPresenterWrapper(wrapper: RoutingPresenterWrapper) {
        self.routingPresenters.append(wrapper)
        self.routingPresenters.sort { (wrapper1, wrapper2) -> Bool in
            return wrapper1.priority > wrapper2.priority
        }
    }
    
    func callHandlerFor(routePattern: String,
                        parameters: [String : Any],
                        routingProviderWrapper: ProviderWrapper,
                        completion: @escaping ()->Void) -> Bool {
        
        if routingProviderWrapper.handlerWrapper?.routePattern == routePattern {
            if let handler = routingProviderWrapper.handlerWrapper?.handler {
                handler(parameters)
                completion()
                return true
            }
        }
        return false
    }
    
    func getController(wrapper: ProviderWrapper,
                       routePattern: String,
                       option: RoutingOption,
                       parameters: [String : Any]) -> UIViewController? {
        
        if let controllerProvider = wrapper.controllerProvider {
            
            if let viewController = controllerProvider.controller(routePattern: routePattern,
                                                                  routingOption: option,
                                                                  parameters: parameters) {
                return viewController
            }
        }
        return nil
    }
    
    func present(viewController: UIViewController,
                 routeResult: RouteResult,
                 option: RoutingOption,
                 params: [String : Any],
                 completion: () -> Void) throws {
        
        var didFoundPresenter = false
        for routingPresenterWrapper in self.routingPresenters {
            
            if routingPresenterWrapper.routingPresenter.isResponsible(option: option) {
                didFoundPresenter = true
                
                //notify all responsible routing observers that the presentation will occour soon
                for observerWrapper in self.routingObservers {
                    if observerWrapper.routePattern == nil || observerWrapper.routePattern == routeResult.routePattern {
                        observerWrapper.routingObserver.willPresent(controller: viewController,
                                                                    routePattern: routeResult.routePattern,
                                                                    routingOption: option,
                                                                    parameters: params,
                                                                    routingPresenter: routingPresenterWrapper.routingPresenter,
                                                                    wireframe: self)
                    }
                }
                
                routingPresenterWrapper.routingPresenter.present(controller: viewController,
                                                                 routePattern: routeResult.routePattern,
                                                                 option: option,
                                                                 parameters: params,
                                                                 wireframe: self,
                                                                 completion: { (viewController, routePattern, option, parameters, wireframe) in
                                                                    completion()
                })
            }
            
        }
        if !didFoundPresenter {
            throw DefaultWireframeError.noRoutingPresenterFoundFor(option: option)
        }
        
    }
    
}
