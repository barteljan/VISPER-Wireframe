//
//  MockRoutingPresenter.swift
//  VISPER-Wireframe_Tests
//
//  Created by bartel on 19.11.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import VISPER_Wireframe_Core

class MockRoutingPresenter: NSObject, RoutingPresenter {

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
    var invokedPresentParameters: (controller: UIViewController, routeResult: RouteResult, option: RoutingOption, wireframe: Wireframe, delegate: RoutingPresenterDelegate)?
    var invokedPresentParametersList = [(controller: UIViewController, routeResult: RouteResult, option: RoutingOption, wireframe: Wireframe, delegate: RoutingPresenterDelegate)]()

    func present(controller: UIViewController, routeResult: RouteResult, option: RoutingOption, wireframe: Wireframe, delegate: RoutingPresenterDelegate, completion: @escaping () -> ()) {
        invokedPresent = true
        invokedPresentCount += 1
        invokedPresentParameters = (controller, routeResult, option, wireframe, delegate)
        invokedPresentParametersList.append((controller, routeResult, option, wireframe, delegate))
        completion()
    }
}
