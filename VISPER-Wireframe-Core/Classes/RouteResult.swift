//
//  RouteResult.swift
//  Pods-VISPER-Wireframe_Example
//
//  Created by bartel on 19.11.17.
//

import Foundation

public protocol RouteResult {
    var routePattern: String {get}
    var routingOption: RoutingOption? {get set}
    var parameters: [String : Any] {get}
}
