//
//  DefaultResultHandler.swift
//  Pods-VISPER-Wireframe_Example
//
//  Created by bartel on 21.11.17.
//

import Foundation
import VISPER_Wireframe_Core
import VISPER_Wireframe_UIViewController

open class DefaultRouteResultHandler : RouteResultHandler {
    
    var routingProviders: [ProviderWrapper]
    
    public init(){
        self.routingProviders = [ProviderWrapper]()
    }
    
    /// Register a route pattern and a handler
    /// The handler will be called if a route matches your route pattern.
    /// (you dont't have to add your pattern manually in this case)
    /// - Parameters:
    ///   - pattern: The route pattern for calling your handler
    ///   - priority: The priority for calling your handler, higher priorities are called first. (Defaults to 0)
    public func addRoutePattern(_ pattern: String, priority: Int, handler: @escaping ([String : Any]) -> Void) throws {
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
    public func add(controllerProvider: ControllerProvider, priority: Int) {
        let providerWrapper = ProviderWrapper(priority: priority,
                                              controllerProvider: controllerProvider,
                                              handlerWrapper: nil)
        self.addRoutingProviderWrapper(wrapper: providerWrapper)
    }
    
    
    /// Handels a RouteResult. (call a registered handler or resolve a controller for this RouteResult)
    ///
    /// - Parameters:
    ///   - routeResult: The RouteResult to be handeld
    ///   - routingOption: A routing option describing how a RouteResult should be handeled (it descibes often how a controller should be presented)
    /// - Throws: throws a RouteResultHandlerError.couldNotHandle(error:) if it could not handle this route result
    public func handleRouteResult(routeResult: RouteResult,
                                routingOption: RoutingOption?,
                                    presenter: RoutingPresenter,
                            presenterDelegate: RoutingDelegate,
                                    wireframe: Wireframe,
                                   completion: @escaping ()->Void) throws {
        
        var controller: UIViewController?
        
        for routingProviderWrapper in self.routingProviders {
            
            // call the handler if one is registered
            // function returns true if a handler was called
            // you can return in that case because you have found the highest priorized handler
            if self.callHandlerFor(routePattern: routeResult.routePattern,
                                   parameters: routeResult.parameters,
                                   routingProviderWrapper: routingProviderWrapper,
                                   completion: completion) {
                return
            }
            
            //since we don't call a handler, we are now shure that our routing option should not be nil
            guard let routingOption = routingOption else {
                throw DefaultWireframeError.noRoutingOptionFoundFor(routePattern: routeResult.routePattern, parameters: routeResult.parameters)
            }
            
            
            if let viewController = self.getController(wrapper: routingProviderWrapper,
                                                       routeResult: routeResult,
                                                       option: routingOption,
                                                       wireframe: wireframe) {
                controller = viewController
                continue
            }
            
        }
        
        //take care that routing option is not nil
        guard let option = routingOption else {
            throw DefaultWireframeError.noRoutingOptionFoundFor(routePattern: routeResult.routePattern, parameters: routeResult.parameters)
        }
        
        //take care that controller is not nil
        guard let viewController = controller else {
            throw DefaultWireframeError.noControllerProviderFoundFor(routePattern: routeResult.routePattern,
                                                                     option: option,
                                                                     parameters: routeResult.parameters)
        }
        
        //present view controller with RoutingPresenter
        try presenter.present(controller: viewController,
                             routeResult: routeResult,
                                  option: option,
                               wireframe: wireframe,
                                delegate: presenterDelegate,
                              completion: completion)
        
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
    
    //MARK: some helper functions
    func addRoutingProviderWrapper(wrapper: ProviderWrapper) {
        self.routingProviders.append(wrapper)
        self.routingProviders.sort { (wrapper1, wrapper2) -> Bool in
            return wrapper1.priority > wrapper2.priority
        }
    }
    
    func getController(wrapper: ProviderWrapper,
                       routeResult: RouteResult,
                       option: RoutingOption,
                       wireframe: Wireframe) -> UIViewController? {
        
        if let controllerProvider = wrapper.controllerProvider {
            
            if let viewController = controllerProvider.controller(routeResult: routeResult,
                                                                  routingOption: option) {
                //notify vc if it should be aware of it
                if let viewController = viewController as? RoutingAwareViewController {
                    viewController.willRoute(wireframe: wireframe, routeResult: routeResult, option: option)
                    viewController.didRoute(wireframe: wireframe, routeResult: routeResult, option: option)
                }
                
                return viewController
            }
        }
        return nil
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
    
    
}
