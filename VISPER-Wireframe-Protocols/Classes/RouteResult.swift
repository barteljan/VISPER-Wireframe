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
