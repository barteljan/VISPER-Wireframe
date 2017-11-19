//
//  MockRoutingPresenter.swift
//  VISPER-Wireframe_Tests
//
//  Created by bartel on 19.11.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
@testable import VISPER_Wireframe

class MockRoutingPresenter: RoutingPresenter {
    
    var id : String?
    var invokedIsResponsible = false
    var invokedIsResponsibleCount = 0
    var invokedIsResponsibleParameters: (option: RoutingOption, Void)?
    var invokedIsResponsibleParametersList = [(option: RoutingOption, Void)]()
    var stubbedIsResponsibleResult: Bool! = false

    func isResponsible(option: RoutingOption) -> Bool {
        invokedIsResponsible = true
        invokedIsResponsibleCount += 1
        invokedIsResponsibleParameters = (option, ())
        invokedIsResponsibleParametersList.append((option, ()))
        return stubbedIsResponsibleResult
    }

    var invokedPresent = false
    var invokedPresentCount = 0
    var invokedPresentParameters: (controller: UIViewController, routePattern: String, option: RoutingOption, parameters: [String: Any], wireframe: Wireframe)?
    var invokedPresentParametersList = [(controller: UIViewController, routePattern: String, option: RoutingOption, parameters: [String: Any], wireframe: Wireframe)]()
    var stubbedPresentCompletionResult: (UIViewController, String, RoutingOption, [String: Any], Wireframe)?

    func present(controller: UIViewController, routePattern: String, option: RoutingOption, parameters: [String: Any], wireframe: Wireframe, completion: (_ controller: UIViewController,
                                                                                                                                                          _ routePattern: String,
                                                                                                                                                          _ option: RoutingOption,
                                                                                                                                                          _ parameters: [String: Any],
                                                                                                                                                          _ wireframe: Wireframe) -> Void) {
        invokedPresent = true
        invokedPresentCount += 1
        invokedPresentParameters = (controller, routePattern, option, parameters, wireframe)
        invokedPresentParametersList.append((controller, routePattern, option, parameters, wireframe))
        if let result = stubbedPresentCompletionResult {
            completion(result.0, result.1, result.2, result.3, result.4)
        }
    }
}
