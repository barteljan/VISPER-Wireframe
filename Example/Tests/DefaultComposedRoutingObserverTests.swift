//
//  DefaultComposedRoutingObserverTests.swift
//  VISPER-Wireframe_Tests
//
//  Created by bartel on 22.11.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest

@testable import VISPER_Wireframe_Core
@testable import VISPER_Wireframe

class DefaultComposedRoutingObserverTests: XCTestCase {
    
    func testAddRoutingObserver() throws {
        
        let id = "mockObserver1"
        let mockObserver1 = MockRoutingObserver()
        mockObserver1.id = id
        
        let composedObserver = DefaultComposedRoutingObserver()
        
        let routePattern = "/testpattern"
        let priority = 10
        composedObserver.add(routingObserver: mockObserver1, priority: priority, routePattern: routePattern)
        
        if composedObserver.routingObservers.count == 1 {
            
            let wrapper = composedObserver.routingObservers[0]
            
            guard let observer = wrapper.routingObserver as? MockRoutingObserver else {
                XCTFail("wrapper should contain our routing observer")
                return
            }
            
            XCTAssertEqual(wrapper.priority, priority)
            XCTAssertEqual(wrapper.routePattern, routePattern)
            XCTAssertEqual(observer.id, mockObserver1.id)
            
        } else {
            XCTFail("There should be one RoutingObserverWrapper in there")
        }
        
    }
    
    func testAddRoutingObserverPriority() throws {
        
        let id1 = "mockObserver1"
        let mockObserver1 = MockRoutingObserver()
        mockObserver1.id = id1
        let priority1 = 5
        
        let id2 = "mockObserver2"
        let mockObserver2 = MockRoutingObserver()
        mockObserver2.id = id2
        let priority2 = 10
        
        let composedObserver = DefaultComposedRoutingObserver()
        
        composedObserver.add(routingObserver: mockObserver1, priority: priority1, routePattern: nil)
        composedObserver.add(routingObserver: mockObserver2, priority: priority2, routePattern: nil)
        
        if composedObserver.routingObservers.count == 2 {
            
            let wrapper1 = composedObserver.routingObservers[0]
            guard let observer1 = wrapper1.routingObserver as? MockRoutingObserver else {
                XCTFail("wrapper should contain our routing observer")
                return
            }
            
            let wrapper2 = composedObserver.routingObservers[1]
            guard let observer2 = wrapper2.routingObserver as? MockRoutingObserver else {
                XCTFail("wrapper should contain our routing observer")
                return
            }
            
            XCTAssertEqual(wrapper1.priority, priority2)
            XCTAssertEqual(observer1.id, mockObserver2.id)
            XCTAssertNil(wrapper1.routePattern)
            
            XCTAssertEqual(wrapper2.priority, priority1)
            XCTAssertEqual(observer2.id, mockObserver1.id)
            XCTAssertNil(wrapper2.routePattern)
        } else {
            XCTFail("There should be two RoutingObserverWrapper in there")
        }
        
    }
    
}
