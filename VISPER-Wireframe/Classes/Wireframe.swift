//
//  Wireframe.swift
//  Pods-SwiftyVISPER_Example
//
//  Created by bartel on 17.11.17.
//

import Foundation

public protocol Wireframe {
    
    /// Route to a new route presenting a view controller
    ///
    /// - Parameters:
    ///   - url: the route of the view controller to be presented
    ///   - option: how should your view controller be presented
    ///   - parameters: a dictionary of parameters send to the presented view controller
    ///   - completion: function called when the view controller was presented
    /// - Throws: throws an error when no controller and/or option provider can be found.
    func route(url: URL,
               option: RoutingOption,
               parameters: [String : Any],
               completion: @escaping () -> Void) throws
    
    
    func canRoute(   url: URL,
                  option: RoutingOption,
              parameters: [String : Any]) -> Bool
    
    func addRoutePattern(pattern: String)
    
    func addRoutePattern(pattern: String,
                         priority: Int,
                         handler: @escaping (_ parameters: [String : Any]) -> Void )
    
    
    func controller(url: URL,
             parameters: [String : Any]) -> UIViewController?
    
    func add(controllerProvider: ControllerProvider, priority: Int)
    
    func add(optionProvider: RoutingOptionProvider, priority: Int)
    
    func add(routingObserver: RoutingObserver, priority: Int)
    
    func add(routingPresenter: RoutingPresenter)
    
}
