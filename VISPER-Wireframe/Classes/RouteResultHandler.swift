//
//  RoutableObjectProvider.swift
//  VISPER-Wireframe-Protocols
//
//  Created by bartel on 21.11.17.
//

import Foundation
import VISPER_Wireframe_Core

public enum RouteResultHandlerError {
    case couldNotHandle(result: RouteResult)
}

public protocol RouteResultHandler {
    
    /// Register a route pattern and a handler
    /// The handler will be called if a route matches your route pattern.
    /// (you dont't have to add your pattern manually in this case)
    /// - Parameters:
    ///   - pattern: The route pattern for calling your handler
    ///   - priority: The priority for calling your handler, higher priorities are called first. (Defaults to 0)
    ///   - handler: A handler called when a route matches your route pattern
    func addRoutePattern(_ pattern: String,
                          priority: Int,
                           handler: @escaping (_ parameters: [String : Any]) -> Void ) throws
    
    /// Add an instance providing a controller for a route
    ///
    /// - Parameters:
    ///   - controllerProvider: instance providing a controller
    ///   - priority: The priority for calling your provider, higher priorities are called first. (Defaults to 0)
    func add(controllerProvider: ControllerProvider, priority: Int)
    
    
    /// Handels a RouteResult. (call a registered handler or resolve a controller for this RouteResult)
    ///
    /// - Parameters:
    ///   - routeResult: The RouteResult to be handeld
    ///   - routingOption: A routing option describing how a RouteResult should be handeled (it descibes often how a controller should be presented)
    /// - Throws: throws a RouteResultHandlerError.couldNotHandle(error:) if it could not handle this route result
    func handleRouteResult(routeResult: RouteResult,
                           routingOption: RoutingOption?,
                           presenter: RoutingPresenter,
                           presenterDelegate: RoutingPresenterDelegate,
                           wireframe: Wireframe,
                           completion: @escaping ()->Void) throws
    
}
