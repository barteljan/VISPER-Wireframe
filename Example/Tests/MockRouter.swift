//
//  MockRouter.swift
//  VISPER-Wireframe_Example
//
//  Created by bartel on 19.11.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
@testable import VISPER_Wireframe

class MockRouter: Router {

    var invokedAdd = false
    var invokedAddCount = 0
    var invokedAddParameters: (routePattern: String, Void)?
    var invokedAddParametersList = [(routePattern: String, Void)]()

    func add(routePattern: String) {
        invokedAdd = true
        invokedAddCount += 1
        invokedAddParameters = (routePattern, ())
        invokedAddParametersList.append((routePattern, ()))
    }

    var invokedRoute = false
    var invokedRouteCount = 0
    var invokedRouteParameters: (url: URL, Void)?
    var invokedRouteParametersList = [(url: URL, Void)]()
    var stubbedRouteResult: RouteResult!

    func route(url: URL) -> RouteResult? {
        invokedRoute = true
        invokedRouteCount += 1
        invokedRouteParameters = (url, ())
        invokedRouteParametersList.append((url, ()))
        return stubbedRouteResult
    }
}
