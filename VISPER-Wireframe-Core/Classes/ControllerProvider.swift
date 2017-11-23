//
//  ControllerProvider.swift
//  VISPER-Wireframe
//
//  Created by bartel on 18.11.17.
//

import Foundation


/// An instance providing a controller for an specific route pattern, routing option,
/// parameter combination if it is responsible for it
public protocol ControllerProvider {
    
    
    /// The provider return a view controller if he is responsible for
    ///
    /// - Parameters:
    ///   - routePattern: The route pattern for which a controller is searched
    ///   - routingOption: The routing option which describes how the created controller will be presented
    ///   - parameters: The parameters (data) provided for view controller presentation
    /// - Returns: a view controller if the provider is responsible for this route pattern, and parameter combination, nil otherwise
    func controller( routeResult: RouteResult,
                   routingOption: RoutingOption) -> UIViewController?
    
}
