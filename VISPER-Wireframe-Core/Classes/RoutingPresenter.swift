//
//  RoutingPresenter.swift
//  VISPER-Wireframe
//
//  Created by bartel on 18.11.17.
//

import Foundation

/// An instance responsible for presenting view controllers
/// Presentation is triggerd by the wireframe after resolving a route match.
public protocol RoutingPresenter {
    
    
    /// Is this presenter responsible for presenting a given routing option
    ///
    /// - Parameter option: a given routing option
    /// - Returns: true if it is responsible, false if not
    func isResponsible(option: RoutingOption) -> Bool
    
    
    
    /// Present a view controller
    ///
    /// - Parameters:
    ///   - controller: The controller to be presented
    ///   - routePattern: The route pattern triggering this respresentation
    ///   - option: The routing option containing all presentation specific data
    ///   - parameters: The parameters (data) extraced from the route, or given by the sender
    ///   - wireframe: The wireframe triggering the presenter
    ///   - completion: a completion called after presentation has occured
    func present(controller: UIViewController,
               routePattern: String,
                     option: RoutingOption,
                 parameters: [String : Any],
                  wireframe: Wireframe,
                 completion: (_ controller: UIViewController,
                              _ routePattern: String,
                              _ option: RoutingOption,
                              _ parameters: [String : Any],
                              _ wireframe: Wireframe) -> Void) throws
}
