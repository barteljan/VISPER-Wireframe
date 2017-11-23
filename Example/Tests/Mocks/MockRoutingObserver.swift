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

class MockRoutingObserver: NSObject,RoutingObserver {
    
    func didPresent(controller: UIViewController, routePattern: String, routingOption: RoutingOption, parameters: [String : Any], routingPresenter: RoutingPresenter, wireframe: Wireframe)  {
        
    }
    
    var id: String?
    var invokedWillPresent = false
    var invokedWillPresentCount = 0
    var invokedWillPresentParameters: (controller: UIViewController, routePattern: String, routingOption: RoutingOption, parameters: [String: Any], routingPresenter: RoutingPresenter, wireframe: Wireframe)?
    var invokedWillPresentParametersList = [(controller: UIViewController, routePattern: String, routingOption: RoutingOption, parameters: [String: Any], routingPresenter: RoutingPresenter, wireframe: Wireframe)]()

    func willPresent(controller: UIViewController, routePattern: String, routingOption: RoutingOption, parameters: [String: Any], routingPresenter: RoutingPresenter, wireframe: Wireframe) {
        invokedWillPresent = true
        invokedWillPresentCount += 1
        invokedWillPresentParameters = (controller, routePattern, routingOption, parameters, routingPresenter, wireframe)
        invokedWillPresentParametersList.append((controller, routePattern, routingOption, parameters, routingPresenter, wireframe))
    }
}
