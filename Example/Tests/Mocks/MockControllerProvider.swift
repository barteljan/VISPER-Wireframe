//
// Created by bartel on 19.11.17.
// Copyright (c) 2017 CocoaPods. All rights reserved.
//

import Foundation
@testable import VISPER_Wireframe_Protocols
@testable import VISPER_Wireframe


class MockControllerProvider: ControllerProvider {

    var id : String?
    
    var invokedController = false
    var invokedControllerCount = 0
    var invokedControllerParameters: (routePattern: String, routingOption: RoutingOption, parameters: [String: Any])?
    var invokedControllerParametersList = [(routePattern: String, routingOption: RoutingOption, parameters: [String: Any])]()
    var stubbedControllerResult: UIViewController!

    func controller(routePattern: String, routingOption: RoutingOption, parameters: [String: Any]) -> UIViewController? {
        invokedController = true
        invokedControllerCount += 1
        invokedControllerParameters = (routePattern, routingOption, parameters)
        invokedControllerParametersList.append((routePattern, routingOption, parameters))
        return stubbedControllerResult
    }
}
