//
//  MockRoutingOptionProvider.swift
//  VISPER-Wireframe_Tests
//
//  Created by bartel on 19.11.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
@testable import VISPER_Wireframe

class MockRoutingOptionProvider: RoutingOptionProvider {

    var id : String? 
    var invokedOption = false
    var invokedOptionCount = 0
    var invokedOptionParameters: (routePattern: String, parameters: [String: Any], currentOption: RoutingOption?)?
    var invokedOptionParametersList = [(routePattern: String, parameters: [String: Any], currentOption: RoutingOption?)]()
    var stubbedOptionResult: RoutingOption!

    func option(routePattern: String, parameters: [String: Any], currentOption: RoutingOption?) -> RoutingOption? {
        invokedOption = true
        invokedOptionCount += 1
        invokedOptionParameters = (routePattern, parameters, currentOption)
        invokedOptionParametersList.append((routePattern, parameters, currentOption))
        return stubbedOptionResult
    }
}
