//
//  DefaultResultHandler.swift
//  Pods-VISPER-Wireframe_Example
//
//  Created by bartel on 21.11.17.
//

import Foundation
import VISPER_Wireframe_Core

open class DefaultRouteResultHandler : RouteResultHandler {
    
    let composedRoutingPresenter : ComposedRoutingPresenter
    
    public init(composedRoutingPresenter : ComposedRoutingPresenter){
        self.composedRoutingPresenter = composedRoutingPresenter
    }
    
    var routingProviders: [ProviderWrapper] = [ProviderWrapper]()
    
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
    
    /// Add an instance observing controllers before they are presented
    ///
    /// - Parameters:
    ///   - routingObserver: An instance observing controllers before they are presented
    ///   - priority: The priority for calling your provider, higher priorities are called first. (Defaults to 0)
    ///   - routePattern: The route pattern to call this observer, the observer is called for every route if this pattern is nil
    public func add(routingObserver: RoutingObserver, priority: Int, routePattern: String?) {
        self.composedRoutingPresenter.add(routingObserver: routingObserver, priority: priority, routePattern: routePattern)
    }
    
    /// Add an instance responsible for presenting view controllers.
    /// It will be triggert after the wireframe resolves a route
    ///
    /// - Parameters:
    ///    - routingPresenter: An instance responsible for presenting view controllers
    ///    - priority: The priority for calling your provider, higher priorities are called first. (Defaults to 0)
    public func add(routingPresenter: RoutingPresenter, priority: Int) {
        self.composedRoutingPresenter.add(routingPresenter: routingPresenter, priority: priority)
    }
    
    /// Handels a RouteResult. (call a registered handler or resolve a controller for this RouteResult)
    ///
    /// - Parameters:
    ///   - routeResult: The RouteResult to be handeld
    ///   - routingOption: A routing option describing how a RouteResult should be handeled (it descibes often how a controller should be presented)
    /// - Throws: throws a RouteResultHandlerError.couldNotHandle(error:) if it could not handle this route result
    public func handleRouteResult(routeResult: RouteResult, routingOption: RoutingOption) throws {
        
        
        
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
    
}
