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
    
    func createWireframe() -> Wireframe {
        
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
        
        let mockProvider = MockControllerProvider()
        
        let wireframe = self.createWireframe()
        
        wireframe.add(controllerProvider: mockProvider, priority: 0)
        
        
        
        XCTFail("implement me")
    }
}
