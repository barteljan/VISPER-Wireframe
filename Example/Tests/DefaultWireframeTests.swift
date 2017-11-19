//
//  DefaultWireframeTests.swift
//  VISPER-Wireframe_Tests
//
//  Created by bartel on 19.11.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import VISPER_Wireframe

class DefaultWireframeTests: XCTestCase {
    
    func createWireframe() -> DefaultWireframe {
        
        let router = MockRouter()
        let wireframe = DefaultWireframe(router: router)
        return wireframe
        
    }
    
    func testAddRoutePattern() throws{
        
        let router = MockRouter()
        let wireframe = DefaultWireframe(router: router)
        
        try wireframe.addRoutePattern("/test/pattern")
        
        XCTAssertTrue(router.invokedAdd)
        
    }
    
    func testAddRoutePatternForHandler(){
        XCTFail("implement me")
    }
    
    func testGetController() {
        XCTFail("implement me")
    }
    
    func testAddControllerProvider() throws {
        
        let id = "mockProvider1"
        let mockProvider = MockControllerProvider()
        mockProvider.id = id
        
        let wireframe = self.createWireframe()
        
        let priority = 10
        wireframe.add(controllerProvider: mockProvider, priority: priority)
        
        if wireframe.routingProviders.count == 1 {
            
            let wrapper = wireframe.routingProviders[0]
            
            guard let controllerProvider = wrapper.controllerProvider as? MockControllerProvider else {
                XCTFail("wrapper should contain our controller provider")
                return
            }
            
            XCTAssertEqual(wrapper.priority, priority)
            XCTAssertEqual(controllerProvider.id, mockProvider.id)
            
        } else {
            XCTFail("There should be one ControllerProvider Wrapper in there")
        }
        
    }
    
    func testAddControllerProviderPriority() throws {
        
        let id1 = "mockProvider1"
        let mockProvider1 = MockControllerProvider()
        mockProvider1.id = id1
        let priority1 = 5
        
        let id2 = "mockProvider2"
        let mockProvider2 = MockControllerProvider()
        mockProvider2.id = id2
        let priority2 = 10
        
        let wireframe = self.createWireframe()
        
        
        wireframe.add(controllerProvider: mockProvider1, priority: priority1)
        wireframe.add(controllerProvider: mockProvider2, priority: priority2)
        
        if wireframe.routingProviders.count == 2 {
            
            let wrapper1 = wireframe.routingProviders[0]
            guard let controllerProvider1 = wrapper1.controllerProvider as? MockControllerProvider else {
                XCTFail("wrapper should contain our controller provider")
                return
            }
            
            let wrapper2 = wireframe.routingProviders[1]
            guard let controllerProvider2 = wrapper2.controllerProvider as? MockControllerProvider else {
                XCTFail("wrapper should contain our controller provider")
                return
            }
            
            XCTAssertEqual(wrapper1.priority, priority2)
            XCTAssertEqual(controllerProvider1.id, mockProvider2.id)
            
            XCTAssertEqual(wrapper2.priority, priority1)
            XCTAssertEqual(controllerProvider2.id, mockProvider1.id)
            
        } else {
            XCTFail("There should be two ControllerProvider Wrapper in there")
        }
        
    }
    
    
    func testAddRoutingOptionProvider() throws {
        
        let id = "mockProvider1"
        let mockProvider = MockRoutingOptionProvider()
        mockProvider.id = id
        
        let wireframe = self.createWireframe()
        
        let priority = 10
        wireframe.add(optionProvider: mockProvider, priority: priority)
        
        if wireframe.optionProviders.count == 1 {
            
            let wrapper = wireframe.optionProviders[0]
            
            guard let provider = wrapper.optionProvider as? MockRoutingOptionProvider else {
                XCTFail("wrapper should contain our routing option provider")
                return
            }
            
            XCTAssertEqual(wrapper.priority, priority)
            XCTAssertEqual(provider.id, mockProvider.id)
            
        } else {
            XCTFail("There should be one RoutingOptionWrapper in there")
        }
        
    }
    
    func testAddRoutingOptionProviderPriority() throws {
        
        let id1 = "mockProvider1"
        let mockProvider1 = MockRoutingOptionProvider()
        mockProvider1.id = id1
        let priority1 = 5
        
        let id2 = "mockProvider2"
        let mockProvider2 = MockRoutingOptionProvider()
        mockProvider2.id = id2
        let priority2 = 10
        
        let wireframe = self.createWireframe()
        
        
        wireframe.add(optionProvider: mockProvider1, priority: priority1)
        wireframe.add(optionProvider: mockProvider2, priority: priority2)
        
        if wireframe.optionProviders.count == 2 {
            
            let wrapper1 = wireframe.optionProviders[0]
            guard let provider1 = wrapper1.optionProvider as? MockRoutingOptionProvider else {
                XCTFail("wrapper should contain our routing option provider")
                return
            }
            
            let wrapper2 = wireframe.optionProviders[1]
            guard let provider2 = wrapper2.optionProvider as? MockRoutingOptionProvider else {
                XCTFail("wrapper should contain our routing option provider")
                return
            }
            
            XCTAssertEqual(wrapper1.priority, priority2)
            XCTAssertEqual(provider1.id, mockProvider2.id)
            
            XCTAssertEqual(wrapper2.priority, priority1)
            XCTAssertEqual(provider2.id, mockProvider1.id)
            
        } else {
            XCTFail("There should be two RoutingOptionWrapper in there")
        }
        
    }
    
}
