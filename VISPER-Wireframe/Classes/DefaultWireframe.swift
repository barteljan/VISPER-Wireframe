//
//  VISPERWireframe.swift
//  Pods-SwiftyVISPER_Example
//
//  Created by bartel on 18.11.17.
//

import Foundation
import VISPER_Wireframe_Core
import VISPER_Wireframe_UIViewController

public enum DefaultWireframeError : Error {
    case noRoutingOptionFoundFor(routePattern: String, parameters: [String : Any])
    case noControllerProviderFoundFor(routePattern: String, option: RoutingOption, parameters: [String : Any])
    case noRoutingPresenterFoundFor(option: RoutingOption)
}


open class DefaultWireframe : Wireframe {
    
    //MARK: internal properties
    
    let router: Router
    let composedOptionProvider: ComposedRoutingOptionProvider
    let composedRoutingPresenter: ComposedRoutingPresenter
    
    let routeResultHandler: RouteResultHandler
    let composedControllerProvider: ComposedControllerProvider
    let routingPresenterDelegate: RoutingPresenterDelegate
    
    //MARK: Initializer
    public init(       router : Router = DefaultRouter(),
        composedOptionProvider: ComposedRoutingOptionProvider = DefaultComposedRoutingOptionProvider(),
      composedRoutingPresenter: ComposedRoutingPresenter = DefaultComposedRoutingPresenter(),
      routingPresenterDelegate: RoutingPresenterDelegate = DefaultRoutingPresenterDelegate(),
            routeResultHandler: RouteResultHandler = DefaultRouteResultHandler(),
    composedControllerProvider: ComposedControllerProvider = DefaultComposedControllerProvider()){
        self.composedOptionProvider = composedOptionProvider
        //self.composedRoutingObserver = composedRoutingObserver
        self.composedRoutingPresenter = composedRoutingPresenter
        self.routingPresenterDelegate = routingPresenterDelegate
        self.routeResultHandler = routeResultHandler
        self.composedControllerProvider = composedControllerProvider
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
        
        if let _ = try self.router.route(url: url, parameters: parameters) {
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
        
        if let routeResult = try self.router.route(url: url, parameters: parameters) {
            
            //get the right routing option
            let routingOption : RoutingOption? = self.composedOptionProvider.option(routeResult: routeResult,
                                                                                   currentOption: option)
            
            try self.routeResultHandler.handleRouteResult(routeResult: routeResult,
                                                        routingOption: routingOption,
                                                            presenter: self.composedRoutingPresenter,
                                                    presenterDelegate: self.routingPresenterDelegate,
                                                            wireframe: self,
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
        
        if let routeResult = try self.router.route(url: url, parameters: parameters) {
            
            return try self.composedControllerProvider.controller(routeResult: routeResult,
                                                                    wireframe: self,
                                                     routingPresenterDelegate: self.routingPresenterDelegate)
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
        try self.routeResultHandler.addRoutePattern(pattern, priority: priority, handler: handler)
    }
    
    /// Add an instance providing a controller for a route
    ///
    /// - Parameters:
    ///   - controllerProvider: instance providing a controller
    ///   - priority: The priority for calling your provider, higher priorities are called first. (Defaults to 0)
    open func add(controllerProvider: ControllerProvider, priority: Int = 0) {
        self.routeResultHandler.add(controllerProvider: controllerProvider, priority: priority)
        self.composedControllerProvider.add(controllerProvider: controllerProvider, priority: priority)
    }
    
    /// Add an instance providing routing options for a route
    ///
    /// - Parameters:
    ///   - optionProvider: instance providing routing options for a route
    ///   - priority: The priority for calling your provider, higher priorities are called first. (Defaults to 0)
    open func add(optionProvider: RoutingOptionProvider, priority: Int = 0) {
        self.composedOptionProvider.add(optionProvider: optionProvider, priority: priority)
    }
    
    /// Add an instance observing controllers before they are presented
    ///
    /// - Parameters:
    ///   - routingObserver: An instance observing controllers before they are presented
    ///   - priority: The priority for calling your provider, higher priorities are called first. (Defaults to 0)
    ///   - routePattern: The route pattern to call this observer, the observer is called for every route if this pattern is nil
    open func add(routingObserver: RoutingObserver, priority: Int = 0, routePattern: String? = nil) {
        self.routingPresenterDelegate.add(routingObserver: routingObserver, priority: priority, routePattern: routePattern)
    }
    
    /// Add an instance responsible for presenting view controllers.
    /// It will be triggert after the wireframe resolves a route
    ///
    /// - Parameters:
    ///    - routingPresenter: An instance responsible for presenting view controllers
    ///    - priority: The priority for calling your provider, higher priorities are called first. (Defaults to 0)
    open func add(routingPresenter: RoutingPresenter,priority: Int = 0) {
        self.composedRoutingPresenter.add(routingPresenter: routingPresenter, priority: priority)
    }
    
}
