//
//  MockRoutingObserver.swift
//  VISPER-Wireframe_Tests
//
//  Created by bartel on 19.11.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
@testable import VISPER_Wireframe_Core
@testable import VISPER_Wireframe

class MockRoutingObserver: NSObject, RoutingObserver {


    var invokedWillPresent = false
    var invokedWillPresentCount = 0
    var invokedWillPresentTime : Date?
    var invokedWillPresentParameters: (controller: UIViewController, routeResult: RouteResult, routingOption: RoutingOption, routingPresenter: RoutingPresenter?, wireframe: Wireframe)?
    var invokedWillPresentParametersList = [(controller: UIViewController, routeResult: RouteResult, routingOption: RoutingOption, routingPresenter: RoutingPresenter?, wireframe: Wireframe)]()

    func willPresent(controller: UIViewController, routeResult: RouteResult, routingOption: RoutingOption, routingPresenter: RoutingPresenter?, wireframe: Wireframe) {
        invokedWillPresent = true
        invokedWillPresentCount += 1
        invokedWillPresentTime = Date()
        invokedWillPresentParameters = (controller, routeResult, routingOption, routingPresenter, wireframe)
        invokedWillPresentParametersList.append((controller, routeResult, routingOption, routingPresenter, wireframe))
    }

    var invokedDidPresent = false
    var invokedDidPresentCount = 0
    var invokedDidPresentTime : Date?
    var invokedDidPresentParameters: (controller: UIViewController, routeResult: RouteResult, routingOption: RoutingOption, routingPresenter: RoutingPresenter?, wireframe: Wireframe)?
    var invokedDidPresentParametersList = [(controller: UIViewController, routeResult: RouteResult, routingOption: RoutingOption, routingPresenter: RoutingPresenter?, wireframe: Wireframe)]()

    func didPresent(controller: UIViewController, routeResult: RouteResult, routingOption: RoutingOption, routingPresenter: RoutingPresenter?, wireframe: Wireframe) {
        invokedDidPresent = true
        invokedDidPresentTime = Date()
        invokedDidPresentCount += 1
        invokedDidPresentParameters = (controller, routeResult, routingOption, routingPresenter, wireframe)
        invokedDidPresentParametersList.append((controller, routeResult, routingOption, routingPresenter, wireframe))
    }
}
