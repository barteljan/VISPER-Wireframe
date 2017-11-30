//
//  DefaultComposedControllerProviderTests.swift
//  VISPER-Wireframe_Tests
//
//  Created by bartel on 30.11.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import VISPER_Wireframe

class DefaultComposedControllerProviderTests: XCTestCase {
    
    func testAddControllerProvider() throws {
        
        let mockProvider = MockControllerProvider()
        
        let composedProvider = DefaultComposedControllerProvider()
        
        let priority = 10
        composedProvider.add(controllerProvider: mockProvider, priority: priority)
        
        if composedProvider.routingProviders.count == 1 {
            
            let wrapper = composedProvider.routingProviders[0]
            
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
        
        let composedProvider = DefaultComposedControllerProvider()
        
        composedProvider.add(controllerProvider: mockProvider1, priority: priority1)
        composedProvider.add(controllerProvider: mockProvider2, priority: priority2)
        
        if composedProvider.routingProviders.count == 2 {
            
            let wrapper1 = composedProvider.routingProviders[0]
            guard let controllerProvider1 = wrapper1.controllerProvider as? MockControllerProvider else {
                XCTFail("wrapper should contain our controller provider")
                return
            }
            
            let wrapper2 = composedProvider.routingProviders[1]
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
    
    
    
}
