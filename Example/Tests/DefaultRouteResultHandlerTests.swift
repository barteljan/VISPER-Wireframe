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
    
    
    func testAddControllerProvider() throws {
        
        let mockProvider = MockControllerProvider()
        
        let routeResultHandler = DefaultRouteResultHandler()
        
        let priority = 10
        routeResultHandler.add(controllerProvider: mockProvider, priority: priority)
        
        if routeResultHandler.routingProviders.count == 1 {
            
            let wrapper = routeResultHandler.routingProviders[0]
            
            guard let controllerProvider = wrapper.controllerProvider as? MockControllerProvider else {
                XCTFail("wrapper should contain our controller provider")
                return
            }
            
            XCTAssertEqual(wrapper.priority, priority)
            XCTAssertEqual(controllerProvider, mockProvider)
            
        } else {
            XCTFail("There should be one ControllerProvider Wrapper in there")
        }
        
    }
    
    func testAddControllerProviderPriority() throws {
        
        
        let mockProvider1 = MockControllerProvider()
        let priority1 = 5
        
        let mockProvider2 = MockControllerProvider()
        let priority2 = 10
        
        let routeResultHandler = DefaultRouteResultHandler()
    
        routeResultHandler.add(controllerProvider: mockProvider1, priority: priority1)
        routeResultHandler.add(controllerProvider: mockProvider2, priority: priority2)
        
        if routeResultHandler.routingProviders.count == 2 {
            
            let wrapper1 = routeResultHandler.routingProviders[0]
            guard let controllerProvider1 = wrapper1.controllerProvider as? MockControllerProvider else {
                XCTFail("wrapper should contain our controller provider")
                return
            }
            
            let wrapper2 = routeResultHandler.routingProviders[1]
            guard let controllerProvider2 = wrapper2.controllerProvider as? MockControllerProvider else {
                XCTFail("wrapper should contain our controller provider")
                return
            }
            
            XCTAssertEqual(wrapper1.priority, priority2)
            XCTAssertEqual(controllerProvider1, mockProvider2)
            
            XCTAssertEqual(wrapper2.priority, priority1)
            XCTAssertEqual(controllerProvider2, mockProvider1)
            
        } else {
            XCTFail("There should be two ControllerProvider Wrapper in there")
        }
        
    }
    
    func testAddRoutePatternForHandler() throws{
        
        let handler1Expectation = self.expectation(description: "Handler1 called")
        let handler1 = { ([String : Any]) -> Void in
            handler1Expectation.fulfill()
        }
        let pattern1 = "/test/pattern1"
        let priority1 = 5
        
        let routeResultHandler = DefaultRouteResultHandler()
        
        try routeResultHandler.addRoutePattern(pattern1, priority: priority1, handler: handler1)
        
        if routeResultHandler.routingProviders.count == 1 {
            
            let wrapper = routeResultHandler.routingProviders[0]
            
            guard let handler = wrapper.handlerWrapper?.handler else {
                XCTFail("wrapper should contain our handler")
                return
            }
            
            XCTAssertEqual(wrapper.priority, priority1)
            
            handler([String : Any]())
            
            self.wait(for: [handler1Expectation], timeout: 5)
            
        } else {
            XCTFail("There should be one ControllerProvider Wrapper in there")
        }
    }
    
    func testAddRoutePatternForHandlerPriority() throws {
        
        let handler1 = { ([String : Any]) -> Void in}
        let pattern1 = "/test/pattern1"
        let priority1 = 5
        
        let handler2 = { ([String : Any]) -> Void in}
        let pattern2 = "/test/pattern1"
        let priority2 = 10
        
        let routeResultHandler = DefaultRouteResultHandler()
        
        
        try routeResultHandler.addRoutePattern(pattern1, priority: priority1, handler: handler1)
        try routeResultHandler.addRoutePattern(pattern2, priority: priority2, handler: handler2)
        
        if routeResultHandler.routingProviders.count == 2 {
            
            let wrapper1 = routeResultHandler.routingProviders[0]
            let wrapper2 = routeResultHandler.routingProviders[1]
            
            XCTAssertEqual(wrapper1.priority, priority2)
            XCTAssertEqual(wrapper2.priority, priority1)
            
        } else {
            XCTFail("There should be two ControllerProvider Wrapper in there")
        }
        
    }
    
    func testHandlerForCorrectRouteResultIsCalled() throws {
        
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
                                           presenterDelegate: delegate,
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

    func testHandlerForCorrectRouteResultCompletionIsCalled() throws {
        
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
                                                 presenterDelegate: delegate,
                                                 wireframe: wireframe,
                                                 completion: {
            completionWasCalled = true
        })
        
        XCTAssertTrue(completionWasCalled)
    }
    
    
}
