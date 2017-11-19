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
    
    func testAddRoutePattern() {
        
        let router = MockRouter()
        let wireframe = DefaultWireframe(router: router)
        
    }
    
    func testAddRoutePatternForHandler(){
        XCTFail("implement me")
    }
    
}
