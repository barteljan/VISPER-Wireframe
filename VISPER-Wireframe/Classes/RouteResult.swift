//
//  RouteResult.swift
//  Pods-VISPER-Wireframe_Example
//
//  Created by bartel on 19.11.17.
//

import Foundation

public protocol RouteResult {
    var routePattern: String {get}
    var parameters: [String : Any] {get}
}


public struct DefaultRouteResult : RouteResult {
    
    public let routePattern: String
    public let parameters: [String : Any]
    
    public init(routePattern: String,parameters: [String : Any]){
        self.routePattern = routePattern
        self.parameters = parameters
    }
    
}
