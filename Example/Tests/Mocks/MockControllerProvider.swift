//
// Created by bartel on 19.11.17.
// Copyright (c) 2017 CocoaPods. All rights reserved.
//

import Foundation
@testable import VISPER_Wireframe_Core
@testable import VISPER_Wireframe


class MockControllerProvider: NSObject, ControllerProvider {


    var invokedIsResponsible = false
    var invokedIsResponsibleCount = 0
    var invokedIsResponsibleParameters: (routeResult: RouteResult, routingOption: RoutingOption?)?
    var invokedIsResponsibleParametersList = [(routeResult: RouteResult, routingOption: RoutingOption?)]()
    var stubbedIsResponsibleResult: Bool! = false

    func isResponsible(routeResult: RouteResult, routingOption: RoutingOption?) -> Bool {
        invokedIsResponsible = true
        invokedIsResponsibleCount += 1
        invokedIsResponsibleParameters = (routeResult, routingOption)
        invokedIsResponsibleParametersList.append((routeResult, routingOption))
        return stubbedIsResponsibleResult
    }

    var invokedMakeController = false
    var invokedMakeControllerCount = 0
    var invokedMakeControllerParameters: (routeResult: RouteResult, routingOption: RoutingOption?)?
    var invokedMakeControllerParametersList = [(routeResult: RouteResult, routingOption: RoutingOption?)]()
    var stubbedMakeControllerResult: UIViewController!

    func makeController(routeResult: RouteResult, routingOption: RoutingOption?) -> UIViewController {
        invokedMakeController = true
        invokedMakeControllerCount += 1
        invokedMakeControllerParameters = (routeResult, routingOption)
        invokedMakeControllerParametersList.append((routeResult, routingOption))
        return stubbedMakeControllerResult
    }
}

