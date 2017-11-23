//
//  RoutingAwareViewController.swift
//  VISPER-Wireframe
//
//  Created by bartel on 19.11.17.
//

import Foundation

public protocol RoutingAwareViewController {
    
    func willRoute(wireframe: Wireframe, routeResult: RouteResult, option: RoutingOption)
    
    func didRoute(wireframe: Wireframe, routeResult: RouteResult, option: RoutingOption)
    
}

public extension RoutingAwareViewController {
    
    func willRoute(wireframe: Wireframe, routeResult: RouteResult, option: RoutingOption){}
    
    func didRoute(wireframe: Wireframe, routeResult: RouteResult, option: RoutingOption){}
    
}
