//
//  RoutingAwareViewController.swift
//  VISPER-Wireframe
//
//  Created by bartel on 19.11.17.
//

import Foundation

public protocol RoutingAwareViewController {
    
    func willRoute(wireframe: Wireframe, routePattern: String, option: RoutingOption, parameters: [String : Any])
    
    func didRoute(wireframe: Wireframe, routePattern: String, option: RoutingOption, parameters: [String : Any])
    
    func willPush(wireframe: Wireframe, routePattern: String, option: RoutingOption, parameters: [String : Any])
    
    func didPush(wireframe: Wireframe, routePattern: String, option: RoutingOption, parameters: [String : Any])
    
    func willPresent(wireframe: Wireframe, routePattern: String, option: RoutingOption, parameters: [String : Any])
    
    func didPresent(wireframe: Wireframe, routePattern: String, option: RoutingOption, parameters: [String : Any])
    
    func willPresentAsRootVC(wireframe: Wireframe, routePattern: String, option: RoutingOption, parameters: [String : Any])
    
    func didPresentAsRootVC(wireframe: Wireframe, routePattern: String, option: RoutingOption, parameters: [String : Any])
}

public extension RoutingAwareViewController {
    
    func willRoute(wireframe: Wireframe, routePattern: String, option: RoutingOption, parameters: [String : Any]){}
    
    func didRoute(wireframe: Wireframe, routePattern: String, option: RoutingOption, parameters: [String : Any]){}
    
    func willPush(wireframe: Wireframe, routePattern: String, option: RoutingOption, parameters: [String : Any]){}
    
    func didPush(wireframe: Wireframe, routePattern: String, option: RoutingOption, parameters: [String : Any]){}
    
    func willPresent(wireframe: Wireframe, routePattern: String, option: RoutingOption, parameters: [String : Any]){}
    
    func didPresent(wireframe: Wireframe, routePattern: String, option: RoutingOption, parameters: [String : Any]){}
    
    func willPresentAsRootVC(wireframe: Wireframe, routePattern: String, option: RoutingOption, parameters: [String : Any]){}
    
    func didPresentAsRootVC(wireframe: Wireframe, routePattern: String, option: RoutingOption, parameters: [String : Any]){}
    
}
