//
//  DefaultRouteResultHandlerTests.swift
//  VISPER-Wireframe_Tests
//
//  Created by bartel on 22.11.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest

@testable import VISPER_Wireframe_Core
@testable import VISPER_Wireframe

class DefaultRouteResultHandlerTests: XCTestCase {
    
    /*
    
    func testCallHandlerForCorrectRouteResult() throws {
        
        var handlerWasCalled = false
        var invokedWithParams : [String : Any]?

        let handler1 = { (parameters: [String : Any]) in
            handlerWasCalled = true
            invokedWithParams = parameters
        }
        
        let pattern1 = "/test/pattern1"
        let priority1 = 5
        
        let routeResultHandler = DefaultRouteResultHandler()
        
        try routeResultHandler.addRoutePattern(pattern1, priority: priority1, handler: handler1)
        
        let params = ["id" : "55"]
        let routeResult = DefaultRouteResult(routePattern: pattern1, parameters: params)
        let option = MockRoutingOption()
        let presenter = MockRoutingPresenter()
        let delegate = MockRoutingDelegate()
        let wireframe = MockWireframe()
        
        try routeResultHandler.handleRouteResult(routeResult: routeResult,
                                               routingOption: option,
                                                   presenter: presenter,
                                             routingDelegate: delegate,
                                                   wireframe: wireframe,
                                                  completion: {
                                        
        })
        
        XCTAssertTrue(handlerWasCalled)
        
        guard let invokedParams = invokedWithParams else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(NSDictionary(dictionary:params), NSDictionary(dictionary:invokedParams))
    }

    func testCallCompletionHandlerForCorrectRouteResult() throws {
        
        var completionWasCalled = false
        let handler1 = { ([String : Any]) -> Void in }
        
        let pattern1 = "/test/pattern1"
        let priority1 = 5
        
        let routeResultHandler = DefaultRouteResultHandler()
        
        try routeResultHandler.addRoutePattern(pattern1, priority: priority1, handler: handler1)
        
        let routeResult = DefaultRouteResult(routePattern: pattern1, parameters: [:])
        let option = MockRoutingOption()
        let presenter = MockRoutingPresenter()
        let delegate = MockRoutingDelegate()
        let wireframe = MockWireframe()
        
        try routeResultHandler.handleRouteResult(routeResult: routeResult,
                                                 routingOption: option,
                                                 presenter: presenter,
                                                 routingDelegate: delegate,
                                                 wireframe: wireframe,
                                                 completion: {
            completionWasCalled = true
        })
        
        XCTAssertTrue(completionWasCalled)
    }
    
    func testDoNotCallHandlerForWrongRouteResult() throws {
        
        var handlerWasCalled = false
        
        let handler1 = { (parameters: [String : Any]) in
            handlerWasCalled = true
        }
        
        let pattern1 = "/test/pattern1"
        let priority1 = 5
        
        let routeResultHandler = DefaultRouteResultHandler()
        
        try routeResultHandler.addRoutePattern(pattern1, priority: priority1, handler: handler1)
        
        let params = ["id" : "55"]
        let wrongPattern = "/this/is/a/wrong/route"
        let routeResult = DefaultRouteResult(routePattern: wrongPattern, parameters: params)
        let option = MockRoutingOption()
        let presenter = MockRoutingPresenter()
        let delegate = MockRoutingDelegate()
        let wireframe = MockWireframe()
        
        XCTAssertThrowsError(try routeResultHandler.handleRouteResult(routeResult: routeResult,
                                                                      routingOption: option,
                                                                      presenter: presenter,
                                                                      routingDelegate: delegate,
                                                                      wireframe: wireframe,
                                                                      completion: {
                                                                        
        }), "should throw an error")
        
        
        XCTAssertFalse(handlerWasCalled)
        
    }
    
    func testHandlerWithHighPriorityIsCalledBeforeLowPriority() throws {
        
        var highPriorityHandlerCalled : Bool = false
        let highPriority = 15
        let highPriorityHandler = { (params: [String : Any]) -> Void in
            highPriorityHandlerCalled = true
        }
 
        var mediumPriorityHandlerCalled = false
        let mediumPriority = 10
        let mediumPriorityHandler = { (params: [String : Any]) -> Void in
            mediumPriorityHandlerCalled = true
        }
        
        var lowPriorityHandlerCalled = false
        let lowPriority = 5
        let lowPriorityHandler = { (params: [String : Any]) -> Void in
            lowPriorityHandlerCalled = true
        }
        
        let pattern = "/test/pattern1"
        
        let routeResultHandler = DefaultRouteResultHandler()
        
        try routeResultHandler.addRoutePattern(pattern, priority: mediumPriority, handler: mediumPriorityHandler)
        try routeResultHandler.addRoutePattern(pattern, priority: highPriority, handler: highPriorityHandler)
        try routeResultHandler.addRoutePattern(pattern, priority: lowPriority, handler: lowPriorityHandler)
    
        let routeResult = DefaultRouteResult(routePattern: pattern, parameters: [:])
        let option = MockRoutingOption()
        let presenter = MockRoutingPresenter()
        let delegate = MockRoutingDelegate()
        let wireframe = MockWireframe()
        
        try routeResultHandler.handleRouteResult(routeResult: routeResult,
                                                 routingOption: option,
                                                 presenter: presenter,
                                                 routingDelegate: delegate,
                                                 wireframe: wireframe,
                                                 completion: {})
        
        XCTAssertTrue(highPriorityHandlerCalled)
        XCTAssertFalse(mediumPriorityHandlerCalled)
        XCTAssertFalse(lowPriorityHandlerCalled)
        
    }
 
    func testThrowsExceptionIfNoRoutingIsPossible() throws{
        
        let handler1 = { (parameters: [String : Any]) in }
        
        let pattern1 = "/test/pattern1"
        let priority1 = 5
        
        let routeResultHandler = DefaultRouteResultHandler()
        
        try routeResultHandler.addRoutePattern(pattern1, priority: priority1, handler: handler1)
        
        let params = ["id" : "55"]
        let wrongPattern = "/this/is/a/wrong/route"
        let routeResult = DefaultRouteResult(routePattern: wrongPattern, parameters: params)
        let option = MockRoutingOption()
        let presenter = MockRoutingPresenter()
        let delegate = MockRoutingDelegate()
        let wireframe = MockWireframe()
        
        XCTAssertThrowsError(try routeResultHandler.handleRouteResult(routeResult: routeResult,
                                                                      routingOption: option,
                                                                      presenter: presenter,
                                                                      routingDelegate: delegate,
                                                                      wireframe: wireframe,
                                                                      completion: {
                                                                        
        }), "should throw an error") { (error) in
            
            guard let wireframeError = error as? DefaultWireframeError else {
                XCTFail("should throw DefaultWireframeError.canNotHandleRoute(routeResult:option:)")
                return
            }
            
            switch wireframeError {
            case .canNotHandleRoute( let errorRouteResult, let errorOption):

                AssertThat(errorRouteResult,
                           isOfType: DefaultRouteResult.self,
                           andEquals: routeResult)
                
                AssertThat(errorOption,
                           isOfType: MockRoutingOption.self,
                           andEquals: option,
                           message: "did provide wrong routing option in DefaultWireframeError.canNotHandleRoute(routeResult:option:)")
        
                
            default:
                XCTFail("should throw DefaultWireframeError.canNotHandleRoute(routeResult:option:)")
            }
            
            
        }
    }
    
    func testCallsControllerProvider() throws {
        
        let controllerProvider = MockControllerProvider()
        controllerProvider.stubbedMakeControllerResult = UIViewController()
        
        let routeResultHandler = DefaultRouteResultHandler()
        routeResultHandler.add(controllerProvider: controllerProvider, priority: 10)
        
        let routeResult = DefaultRouteResult(routePattern: "/this/is/a/route", parameters: ["id" : "55"])
        let option = MockRoutingOption()
        let presenter = MockRoutingPresenter()
        let delegate = MockRoutingDelegate()
        let wireframe = MockWireframe()
        
        try routeResultHandler.handleRouteResult(routeResult: routeResult,
                                               routingOption: option,
                                                   presenter: presenter,
                                             routingDelegate: delegate,
                                                   wireframe: wireframe,
                                                  completion: {})
        
        XCTAssertTrue(controllerProvider.invokedMakeController)
        
        AssertThat(controllerProvider.invokedMakeControllerParameters?.routeResult, isOfType: DefaultRouteResult.self, andEquals: routeResult)
        AssertThat(controllerProvider.invokedMakeControllerParameters?.routingOption, isOfType: MockRoutingOption.self, andEquals: option)
        
    }
    
    func testCallsPresenter() throws {
        
        let controllerProvider = MockControllerProvider()
        let viewController = UIViewController()
        controllerProvider.stubbedMakeControllerResult = viewController
        
        let routeResultHandler = DefaultRouteResultHandler()
        routeResultHandler.add(controllerProvider: controllerProvider, priority: 10)
        
        let routeResult = DefaultRouteResult(routePattern: "/this/is/a/route", parameters: ["id" : "55"])
        let option = MockRoutingOption()
        let presenter = MockRoutingPresenter()
        let delegate = MockRoutingDelegate()
        let wireframe = MockWireframe()
        
        try routeResultHandler.handleRouteResult(routeResult: routeResult,
                                                 routingOption: option,
                                                 presenter: presenter,
                                                 routingDelegate: delegate,
                                                 wireframe: wireframe,
                                                 completion: {})
        
        XCTAssertTrue(presenter.invokedPresent)
        AssertThat(presenter.invokedPresentParameters?.controller, isOfType: UIViewController.self, andEquals: viewController)
        AssertThat(presenter.invokedPresentParameters?.delegate, isOfType: MockRoutingDelegate.self, andEquals: delegate)
        AssertThat(presenter.invokedPresentParameters?.option, isOfType: MockRoutingOption.self, andEquals: option)
        AssertThat(presenter.invokedPresentParameters?.routeResult, isOfType: DefaultRouteResult.self, andEquals: routeResult)
        AssertThat(presenter.invokedPresentParameters?.wireframe, isOfType: MockWireframe.self, andEquals: wireframe)
        
    }
    */
}
