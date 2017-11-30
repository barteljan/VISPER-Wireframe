//
//  DefaultRoutingHandlerContainerTests.swift
//  VISPER-Wireframe_Tests
//
//  Created by bartel on 30.11.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import VISPER_Wireframe
@testable import VISPER_Wireframe_Core

class DefaultRoutingHandlerContainerTests: XCTestCase {
    
    func testAddRoutePatternForHandler() throws{
        
        let handlerExpectation = self.expectation(description: "Handler1 called")
        let handler = { (routeResult: RouteResult) -> Void in
            handlerExpectation.fulfill()
        }
        let pattern = "/test/pattern1"
        let priority = 5
        
        let container = DefaultRoutingHandlerContainer()
        
        try container.add(priority: priority,
                    responsibleFor: { result,option in return result.routePattern == pattern },
                           handler: handler)
        
        if container.routeHandlers.count == 1 {
            
            let wrapper = container.routeHandlers[0]
            
            let handler = wrapper.handler
            
            XCTAssertEqual(wrapper.priority, priority)
            
            handler(DefaultRouteResult(routePattern: "/some/pattern", parameters: [:]))
            
            self.wait(for: [handlerExpectation], timeout: 5)
            
        } else {
            XCTFail("There should be one Handler Wrapper in there")
        }
    }
    
    func testAddRoutePatternForHandlerPriority() throws {
        
        var didCalllLowPriorityHandler = false
        let lowPriorityHandler = { (routeResult: RouteResult) -> Void in
            didCalllLowPriorityHandler = true
        }
        let lowPriorityPattern = "/test/pattern1"
        let lowPriority = 5
        
        var didCallHighPriorityHandler = false
        let highPriorityHandler = { (routeResult: RouteResult) -> Void in
            didCallHighPriorityHandler = true
        }
        let highPriorityPattern = "/test/pattern2"
        let highPriority = 10
        
        let container = DefaultRoutingHandlerContainer()
        
        
        try container.add(priority: lowPriority,
                          responsibleFor: { result,option in return result.routePattern == lowPriorityPattern },
                          handler: lowPriorityHandler)
        try container.add(priority: highPriority,
                          responsibleFor: { result,option in return result.routePattern == highPriorityPattern },
                          handler: highPriorityHandler)
        
        if container.routeHandlers.count == 2 {
            
            let firstWrapper = container.routeHandlers[0]
            let secondWrapper = container.routeHandlers[1]
            
            XCTAssertEqual(firstWrapper.priority, highPriority)
            XCTAssertEqual(secondWrapper.priority, lowPriority)
            
            XCTAssertFalse(didCallHighPriorityHandler)
            firstWrapper.handler(DefaultRouteResult(routePattern: "/some/pattern", parameters: [:]))
            XCTAssertTrue(didCallHighPriorityHandler)
            
            XCTAssertFalse(didCalllLowPriorityHandler)
            secondWrapper.handler(DefaultRouteResult(routePattern: "/some/pattern", parameters: [:]))
            XCTAssertTrue(didCalllLowPriorityHandler)
            
        } else {
            XCTFail("There should be two Handler Wrapper in there")
        }
        
    }
    
    func testCallsResponsibleHandler() throws {
        
        let handler = { (routeResult: RouteResult) -> Void in }
        let priority = 5
        let routeResult = DefaultRouteResult(routePattern: "/test/pattern1", parameters: [:])
        let routingOption = MockRoutingOption()
        
        let container = DefaultRoutingHandlerContainer()
        
        var didCallResponsibleForHandler = false
        try container.add(priority: priority,
                          responsibleFor: { result,option in
                                didCallResponsibleForHandler = true
                                return true
                          },
                          handler: handler)
        
        _ = container.handler(routeResult: routeResult, routingOption: routingOption)
        
        XCTAssertTrue(didCallResponsibleForHandler)
        
    }
    
}
