//
// Created by bartel on 19.11.17.
// Copyright (c) 2017 CocoaPods. All rights reserved.
//

import Foundation
@testable import VISPER_Wireframe_Core
@testable import VISPER_Wireframe


class MockControllerProvider: NSObject,ControllerProvider {


    var invokedController = false
    var invokedControllerCount = 0
    var invokedControllerParameters: (routeResult: RouteResult, routingOption: RoutingOption)?
    var invokedControllerParametersList = [(routeResult: RouteResult, routingOption: RoutingOption)]()
    var stubbedControllerResult: UIViewController!

    func controller(routeResult: RouteResult, routingOption: RoutingOption) -> UIViewController? {
        invokedController = true
        invokedControllerCount += 1
        invokedControllerParameters = (routeResult, routingOption)
        invokedControllerParametersList.append((routeResult, routingOption))
        return stubbedControllerResult
    }
}

