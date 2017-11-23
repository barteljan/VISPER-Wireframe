//
//  DefaultComposedRoutingPresenterTests.swift
//  VISPER-Wireframe_Tests
//
//  Created by bartel on 22.11.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest

@testable import VISPER_Wireframe_Core
@testable import VISPER_Wireframe

class DefaultComposedRoutingPresenterTests: XCTestCase {
    
    func testAddRoutingPresenter() throws {
        
        let mockPresenter1 = MockRoutingPresenter()
        
        let composedPresenter = DefaultComposedRoutingPresenter()
        
        let priority = 10
        composedPresenter.add(routingPresenter: mockPresenter1, priority: priority)
        
        if composedPresenter.routingPresenters.count == 1 {
            
            let wrapper = composedPresenter.routingPresenters[0]
            
            guard let presenter = wrapper.routingPresenter as? MockRoutingPresenter else {
                XCTFail("wrapper should contain our routing observer")
                return
            }
            
            XCTAssertEqual(wrapper.priority, priority)
            XCTAssertEqual(presenter, mockPresenter1)
            
        } else {
            XCTFail("There should be one RoutingObserverWrapper in there")
        }
        
    }
    
    func testAddRoutingPresenterPriority() throws {
        
        let mockPresenter1 = MockRoutingPresenter()
        let priority1 = 5
        
        let mockPresenter2 = MockRoutingPresenter()
        let priority2 = 10
        
        let composedPresenter = DefaultComposedRoutingPresenter()
        
        composedPresenter.add(routingPresenter: mockPresenter1, priority: priority1)
        composedPresenter.add(routingPresenter: mockPresenter2, priority: priority2)
        
        if composedPresenter.routingPresenters.count == 2 {
            
            let wrapper1 = composedPresenter.routingPresenters[0]
            guard let presenter1 = wrapper1.routingPresenter as? MockRoutingPresenter else {
                XCTFail("wrapper should contain our routing observer")
                return
            }
            
            let wrapper2 = composedPresenter.routingPresenters[1]
            guard let presenter2 = wrapper2.routingPresenter as? MockRoutingPresenter else {
                XCTFail("wrapper should contain our routing observer")
                return
            }
            
            XCTAssertEqual(wrapper1.priority, priority2)
            XCTAssertEqual(presenter1, mockPresenter2)
            
            XCTAssertEqual(wrapper2.priority, priority1)
            XCTAssertEqual(presenter2, mockPresenter1)
            
        } else {
            XCTFail("There should be two RoutingObserverWrapper in there")
        }
        
    }
  
    
}
