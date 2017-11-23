//
//  MockComposedOptionProvider.swift
//  VISPER-Wireframe_Tests
//
//  Created by bartel on 21.11.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import VISPER_Wireframe_Core
import VISPER_Wireframe


class MockComposedOptionProvider: NSObject, ComposedRoutingOptionProvider {


    var invokedAdd = false
    var invokedAddCount = 0
    var invokedAddParameters: (optionProvider: RoutingOptionProvider, priority: Int)?
    var invokedAddParametersList = [(optionProvider: RoutingOptionProvider, priority: Int)]()

    func add(optionProvider: RoutingOptionProvider, priority: Int) {
        invokedAdd = true
        invokedAddCount += 1
        invokedAddParameters = (optionProvider, priority)
        invokedAddParametersList.append((optionProvider, priority))
    }

    var invokedOption = false
    var invokedOptionCount = 0
    var invokedOptionParameters: (routeResult: RouteResult, currentOption: RoutingOption?)?
    var invokedOptionParametersList = [(routeResult: RouteResult, currentOption: RoutingOption?)]()
    var stubbedOptionResult: RoutingOption!

    func option(routeResult: RouteResult, currentOption: RoutingOption?) -> RoutingOption? {
        invokedOption = true
        invokedOptionCount += 1
        invokedOptionParameters = (routeResult, currentOption)
        invokedOptionParametersList.append((routeResult, currentOption))
        return stubbedOptionResult
    }
}
