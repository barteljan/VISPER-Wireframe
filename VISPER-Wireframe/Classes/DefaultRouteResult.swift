//
//  RouteResult.swift
//  Pods-VISPER-Wireframe_Example
//
//  Created by bartel on 19.11.17.
//

import Foundation
import VISPER_Wireframe_Core

public struct DefaultRouteResult : RouteResult {
    
    public let routePattern: String
    public let parameters: [String : Any]
    
    public init(routePattern: String,parameters: [String : Any]){
        self.routePattern = routePattern
        self.parameters = parameters
    }
    
}
