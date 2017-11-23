//
//  MockRoutingOptionProvider.swift
//  VISPER-Wireframe_Tests
//
//  Created by bartel on 19.11.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
@testable import VISPER_Wireframe_Core
@testable import VISPER_Wireframe

class MockRoutingOptionProvider: NSObject, RoutingOptionProvider {

    var invokedOption = false
    var invokedOptionCount = 0
    var invokedOptionParameters: (routeResult: RouteResult, currentOption: RoutingOption?)?
    var invokedOptionParametersList = [(routeResult: RouteResult, currentOption: RoutingOption?)]()
    var stubbedOptionResult: RoutingOption!
    var invokedOptionTime : Date?

    func option(routeResult: RouteResult, currentOption: RoutingOption?) -> RoutingOption? {
        invokedOption = true
        invokedOptionTime = Date()
        invokedOptionCount += 1
        invokedOptionParameters = (routeResult, currentOption)
        invokedOptionParametersList.append((routeResult, currentOption))
        return stubbedOptionResult
    }
}

