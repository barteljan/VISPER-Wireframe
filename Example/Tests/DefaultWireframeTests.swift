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
    

    func testAddRoutingObserverCallsComposedRoutingPresenter() throws {
        
        let mockObserver1 = MockRoutingObserver()
        
        let router = MockRouter()
        
        let composedOptionProvider = MockComposedOptionProvider()
        let composedRoutingObserver = MockComposedRoutingObserver()
        
        let wireframe = DefaultWireframe(router: router,
                         composedOptionProvider: composedOptionProvider)
        
        /*
        DefaultWireframe(router: <#T##Router#>,
         composedOptionProvider: <#T##ComposedRoutingOptionProvider#>,
       composedRoutingPresenter: <#T##ComposedRoutingPresenter#>,
       routingPresenterDelegate: <#T##RoutingPresenterDelegate#>,
             routeResultHandler: <#T##RouteResultHandler#>,
     composedControllerProvider: <#T##ComposedControllerProvider#>)
        */
        
        
        let priority = 10
        wireframe.add(routingObserver: mockObserver1, priority: priority)
        
        XCTAssertTrue(composedRoutingObserver.invokedAdd)
        
        guard let paramObserver = composedRoutingObserver.invokedAddParameters?.routingObserver as? MockRoutingObserver else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(paramObserver, mockObserver1)
        
    }
    
    
}

