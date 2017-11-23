//
//  File.swift
//  VISPER-Wireframe
//
//  Created by bartel on 22.11.17.
//

import Foundation
import VISPER_Wireframe_Core

public protocol ComposedControllerProvider  {
    
    /// Add an instance providing a controller for a route
    ///
    /// - Parameters:
    ///   - controllerProvider: instance providing a controller
    ///   - priority: The priority for calling your provider, higher priorities are called first. (Defaults to 0)
    func add(controllerProvider: ControllerProvider, priority: Int)
    
    
    /// The provider return a view controller if he is responsible for
    ///
    /// - Parameters:
    ///   - routePattern: The route pattern for which a controller is searched
    ///   - routingOption: The routing option which describes how the created controller will be presented
    ///   - parameters: The parameters (data) provided for view controller presentation
    /// - Returns: a view controller if the provider is responsible for this route pattern, and parameter combination, nil otherwise
    func controller(routeResult: RouteResult,
                      wireframe: Wireframe,
       routingPresenterDelegate: RoutingPresenterDelegate) throws -> UIViewController?
    
}
