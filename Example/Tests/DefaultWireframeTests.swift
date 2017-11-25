//
//  DefaultWireframeTests.swift
//  VISPER-Wireframe_Tests
//
//  Created by bartel on 19.11.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import VISPER_Wireframe_Core
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
    
    func testGetController() {
        XCTFail("implement me")
    }
    
    func testAddRoutingOptionProviderCallsComposedOptionProvider() throws {
        
        let mockProvider = MockRoutingOptionProvider()
        
        let router = MockRouter()
        let composedRoutingOptionProvider = MockComposedOptionProvider()
        let wireframe = DefaultWireframe(router: router,
                                         composedOptionProvider: composedRoutingOptionProvider)
        
        let priority = 10
        wireframe.add(optionProvider: mockProvider, priority: priority)
        
        if let calledWithOptionProvider = composedRoutingOptionProvider.invokedAddParameters?.optionProvider as? MockRoutingOptionProvider {
            XCTAssertEqual(calledWithOptionProvider, mockProvider)
        }else {
            XCTFail()
        }
        
    }
    
    
}

