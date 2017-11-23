//
//  MockWireframe.swift
//  VISPER-Wireframe_Example
//
//  Created by bartel on 23.11.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation

import VISPER_Wireframe_Core
import VISPER_Wireframe

class MockWireframe: NSObject, Wireframe {

    var invokedCanRoute = false
    var invokedCanRouteCount = 0
    var invokedCanRouteParameters: (url: URL, parameters: [String: Any])?
    var invokedCanRouteParametersList = [(url: URL, parameters: [String: Any])]()
    var stubbedCanRouteResult: Bool! = false

    func canRoute(url: URL, parameters: [String: Any]) -> Bool {
        invokedCanRoute = true
        invokedCanRouteCount += 1
        invokedCanRouteParameters = (url, parameters)
        invokedCanRouteParametersList.append((url, parameters))
        return stubbedCanRouteResult
    }

    var invokedRoute = false
    var invokedRouteCount = 0
    var invokedRouteParameters: (url: URL, option: RoutingOption?, parameters: [String: Any])?
    var invokedRouteParametersList = [(url: URL, option: RoutingOption?, parameters: [String: Any])]()

    func route(url: URL, option: RoutingOption?, parameters: [String: Any], completion: @escaping () -> Void) {
        invokedRoute = true
        invokedRouteCount += 1
        invokedRouteParameters = (url, option, parameters)
        invokedRouteParametersList.append((url, option, parameters))
        completion()
    }

    var invokedController = false
    var invokedControllerCount = 0
    var invokedControllerParameters: (url: URL, parameters: [String: Any])?
    var invokedControllerParametersList = [(url: URL, parameters: [String: Any])]()
    var stubbedControllerResult: UIViewController!

    func controller(url: URL, parameters: [String: Any]) -> UIViewController? {
        invokedController = true
        invokedControllerCount += 1
        invokedControllerParameters = (url, parameters)
        invokedControllerParametersList.append((url, parameters))
        return stubbedControllerResult
    }

    var invokedAddRoutePattern = false
    var invokedAddRoutePatternCount = 0
    var invokedAddRoutePatternParameters: (pattern: String, Void)?
    var invokedAddRoutePatternParametersList = [(pattern: String, Void)]()

    func addRoutePattern(_ pattern: String) {
        invokedAddRoutePattern = true
        invokedAddRoutePatternCount += 1
        invokedAddRoutePatternParameters = (pattern, ())
        invokedAddRoutePatternParametersList.append((pattern, ()))
    }

    var invokedAddRoutePatternPriority = false
    var invokedAddRoutePatternPriorityCount = 0
    var invokedAddRoutePatternPriorityParameters: (pattern: String, priority: Int)?
    var invokedAddRoutePatternPriorityParametersList = [(pattern: String, priority: Int)]()
    var stubbedAddRoutePatternHandlerResult: ([String: Any], Void)?

    func addRoutePattern(_ pattern: String, priority: Int, handler: @escaping (_ parameters: [String: Any]) -> Void) {
        invokedAddRoutePatternPriority = true
        invokedAddRoutePatternPriorityCount += 1
        invokedAddRoutePatternPriorityParameters = (pattern, priority)
        invokedAddRoutePatternPriorityParametersList.append((pattern, priority))
        if let result = stubbedAddRoutePatternHandlerResult {
            handler(result.0)
        }
    }

    var invokedAddControllerProvider = false
    var invokedAddControllerProviderCount = 0
    var invokedAddControllerProviderParameters: (controllerProvider: ControllerProvider, priority: Int)?
    var invokedAddControllerProviderParametersList = [(controllerProvider: ControllerProvider, priority: Int)]()

    func add(controllerProvider: ControllerProvider, priority: Int) {
        invokedAddControllerProvider = true
        invokedAddControllerProviderCount += 1
        invokedAddControllerProviderParameters = (controllerProvider, priority)
        invokedAddControllerProviderParametersList.append((controllerProvider, priority))
    }

    var invokedAddOptionProvider = false
    var invokedAddOptionProviderCount = 0
    var invokedAddOptionProviderParameters: (optionProvider: RoutingOptionProvider, priority: Int)?
    var invokedAddOptionProviderParametersList = [(optionProvider: RoutingOptionProvider, priority: Int)]()

    func add(optionProvider: RoutingOptionProvider, priority: Int) {
        invokedAddOptionProvider = true
        invokedAddOptionProviderCount += 1
        invokedAddOptionProviderParameters = (optionProvider, priority)
        invokedAddOptionProviderParametersList.append((optionProvider, priority))
    }

    var invokedAddRoutingObserver = false
    var invokedAddRoutingObserverCount = 0
    var invokedAddRoutingObserverParameters: (routingObserver: RoutingObserver, priority: Int, routePattern: String?)?
    var invokedAddRoutingObserverParametersList = [(routingObserver: RoutingObserver, priority: Int, routePattern: String?)]()

    func add(routingObserver: RoutingObserver, priority: Int, routePattern: String?) {
        invokedAddRoutingObserver = true
        invokedAddRoutingObserverCount += 1
        invokedAddRoutingObserverParameters = (routingObserver, priority, routePattern)
        invokedAddRoutingObserverParametersList.append((routingObserver, priority, routePattern))
    }

    var invokedAddRoutingPresenter = false
    var invokedAddRoutingPresenterCount = 0
    var invokedAddRoutingPresenterParameters: (routingPresenter: RoutingPresenter, priority: Int)?
    var invokedAddRoutingPresenterParametersList = [(routingPresenter: RoutingPresenter, priority: Int)]()

    func add(routingPresenter: RoutingPresenter, priority: Int) {
        invokedAddRoutingPresenter = true
        invokedAddRoutingPresenterCount += 1
        invokedAddRoutingPresenterParameters = (routingPresenter, priority)
        invokedAddRoutingPresenterParametersList.append((routingPresenter, priority))
    }
}
