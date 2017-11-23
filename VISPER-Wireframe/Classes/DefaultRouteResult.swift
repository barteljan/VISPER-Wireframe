//
//  RouteResult.swift
//  Pods-VISPER-Wireframe_Example
//
//  Created by bartel on 19.11.17.
//

import Foundation
import VISPER_Wireframe_Core

public struct DefaultRouteResult : RouteResult, Equatable {

    public let routePattern: String
    public let parameters: [String : Any]
    
    public init(routePattern: String,parameters: [String : Any]){
        self.routePattern = routePattern
        self.parameters = parameters
    }
    
    public static func ==(lhs: DefaultRouteResult, rhs: DefaultRouteResult) -> Bool {
        
        let lhsParams = NSDictionary(dictionary: lhs.parameters)
        let rhsParams = NSDictionary(dictionary: rhs.parameters)
        
        return lhs.routePattern == rhs.routePattern &&
               lhsParams == rhsParams
    }
    
}
