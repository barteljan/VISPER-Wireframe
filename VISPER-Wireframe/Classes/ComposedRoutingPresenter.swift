//
//  ComposedRoutingPresenter.swift
//  Pods-VISPER-Wireframe_Example
//
//  Created by bartel on 21.11.17.
//

import Foundation
import VISPER_Wireframe_Core

public protocol ComposedRoutingPresenter : RoutingPresenter{
    
    /// Add an instance observing controllers before they are presented
    ///
    /// - Parameters:
    ///   - routingObserver: An instance observing controllers before they are presented
    ///   - priority: The priority for calling your provider, higher priorities are called first. (Defaults to 0)
    ///   - routePattern: The route pattern to call this observer, the observer is called for every route if this pattern is nil
    func add(routingObserver: RoutingObserver, priority: Int, routePattern: String?)
    
    /// Add an instance responsible for presenting view controllers.
    /// It will be triggert after the wireframe resolves a route
    ///
    /// - Parameters:
    ///    - routingPresenter: An instance responsible for presenting view controllers
    ///    - priority: The priority for calling your provider, higher priorities are called first. (Defaults to 0)
    func add(routingPresenter: RoutingPresenter,priority: Int)
    
}
