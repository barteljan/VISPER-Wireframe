//
//  ComposedRoutingObserverDelegate.swift
//  Pods-VISPER-Wireframe_Example
//
//  Created by bartel on 22.11.17.
//

import Foundation

public protocol RoutingPresenterDelegate {
    
    /// Event that indicates that a view controller will be presented
    ///
    /// - Parameters:
    ///   - controller: The view controller that will be presented
    ///   - routePattern: The route pattern triggering the presentation
    ///   - routingOption: The RoutingOption describing how the controller will be presented
    ///   - parameters: The parameters (data) extraced from the route, or given by the sender
    ///   - routingPresenter: The RoutingPresenter responsible for presenting the controller
    ///   - wireframe: The wireframe presenting the view controller
    func willPresent(controller: UIViewController,
                   routePattern: String,
                  routingOption: RoutingOption,
                     parameters: [String : Any],
               routingPresenter: RoutingPresenter?,
                      wireframe: Wireframe) throws
    
    
    /// Event that indicates that a view controller was presented
    ///
    /// - Parameters:
    ///   - controller: The view controller that will be presented
    ///   - routePattern: The route pattern triggering the presentation
    ///   - routingOption: The RoutingOption describing how the controller will be presented
    ///   - parameters: The parameters (data) extraced from the route, or given by the sender
    ///   - routingPresenter: The RoutingPresenter responsible for presenting the controller
    ///   - wireframe: The wireframe presenting the view controller
    func didPresent( controller: UIViewController,
                   routePattern: String,
                  routingOption: RoutingOption,
                     parameters: [String : Any],
               routingPresenter: RoutingPresenter?,
                      wireframe: Wireframe)
    
}
