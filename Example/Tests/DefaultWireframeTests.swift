//
//  DefaultWireframeTests.swift
//  VISPER-Wireframe_Tests
//
//  Created by bartel on 19.11.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import VISPER_Wireframe_Protocols
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
    
    func testAddRoutePatternForHandler() throws{
        
        let handler1Expectation = self.expectation(description: "Handler1 called")
        let handler1 = { ([String : Any]) -> Void in
            handler1Expectation.fulfill()
        }
        let pattern1 = "/test/pattern1"
        let priority1 = 5
        
        let wireframe = self.createWireframe()
        
        try wireframe.addRoutePattern(pattern1, priority: priority1, handler: handler1)
        
        if wireframe.routingProviders.count == 1 {
            
            let wrapper = wireframe.routingProviders[0]
            
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
        
        let wireframe = self.createWireframe()
        
        
        try wireframe.addRoutePattern(pattern1, priority: priority1, handler: handler1)
        try wireframe.addRoutePattern(pattern2, priority: priority2, handler: handler2)
        
        if wireframe.routingProviders.count == 2 {
            
            let wrapper1 = wireframe.routingProviders[0]
            let wrapper2 = wireframe.routingProviders[1]
            
            XCTAssertEqual(wrapper1.priority, priority2)
            XCTAssertEqual(wrapper2.priority, priority1)
            
        } else {
            XCTFail("There should be two ControllerProvider Wrapper in there")
        }
        
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
    
    func testAddRoutingObserver() throws {
        
        let id = "mockObserver1"
        let mockObserver1 = MockRoutingObserver()
        mockObserver1.id = id
        
        let wireframe = self.createWireframe()
        
        let priority = 10
        wireframe.add(routingObserver: mockObserver1, priority: priority)
        
        if wireframe.routingObservers.count == 1 {
            
            let wrapper = wireframe.routingObservers[0]
            
            guard let observer = wrapper.routingObserver as? MockRoutingObserver else {
                XCTFail("wrapper should contain our routing observer")
                return
            }
            
            XCTAssertEqual(wrapper.priority, priority)
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
        
        let wireframe = self.createWireframe()
        
        wireframe.add(routingObserver: mockObserver1, priority: priority1)
        wireframe.add(routingObserver: mockObserver2, priority: priority2)
        
        if wireframe.routingObservers.count == 2 {
            
            let wrapper1 = wireframe.routingObservers[0]
            guard let observer1 = wrapper1.routingObserver as? MockRoutingObserver else {
                XCTFail("wrapper should contain our routing observer")
                return
            }
            
            let wrapper2 = wireframe.routingObservers[1]
            guard let observer2 = wrapper2.routingObserver as? MockRoutingObserver else {
                XCTFail("wrapper should contain our routing observer")
                return
            }
            
            XCTAssertEqual(wrapper1.priority, priority2)
            XCTAssertEqual(observer1.id, mockObserver2.id)
            
            XCTAssertEqual(wrapper2.priority, priority1)
            XCTAssertEqual(observer2.id, mockObserver1.id)
            
        } else {
            XCTFail("There should be two RoutingObserverWrapper in there")
        }
        
    }
    
    func testAddRoutingPresenter() throws {
        
        let id = "mockPresenter1"
        let mockPresenter1 = MockRoutingPresenter()
        mockPresenter1.id = id
        
        let wireframe = self.createWireframe()
        
        let priority = 10
        wireframe.add(routingPresenter: mockPresenter1, priority: priority)
        
        if wireframe.routingPresenters.count == 1 {
            
            let wrapper = wireframe.routingPresenters[0]
            
            guard let presenter = wrapper.routingPresenter as? MockRoutingPresenter else {
                XCTFail("wrapper should contain our routing observer")
                return
            }
            
            XCTAssertEqual(wrapper.priority, priority)
            XCTAssertEqual(presenter.id, mockPresenter1.id)
            
        } else {
            XCTFail("There should be one RoutingObserverWrapper in there")
        }
        
    }
    
    func testAddRoutingPresenterPriority() throws {
        
        let id1 = "mockPresenter1"
        let mockPresenter1 = MockRoutingPresenter()
        mockPresenter1.id = id1
        let priority1 = 5
        
        let id2 = "mockPresenter2"
        let mockPresenter2 = MockRoutingPresenter()
        mockPresenter2.id = id2
        let priority2 = 10
        
        let wireframe = self.createWireframe()
        
        wireframe.add(routingPresenter: mockPresenter1, priority: priority1)
        wireframe.add(routingPresenter: mockPresenter2, priority: priority2)
        
        if wireframe.routingPresenters.count == 2 {
            
            let wrapper1 = wireframe.routingPresenters[0]
            guard let presenter1 = wrapper1.routingPresenter as? MockRoutingPresenter else {
                XCTFail("wrapper should contain our routing observer")
                return
            }
            
            let wrapper2 = wireframe.routingPresenters[1]
            guard let presenter2 = wrapper2.routingPresenter as? MockRoutingPresenter else {
                XCTFail("wrapper should contain our routing observer")
                return
            }
            
            XCTAssertEqual(wrapper1.priority, priority2)
            XCTAssertEqual(presenter1.id, mockPresenter2.id)
            
            XCTAssertEqual(wrapper2.priority, priority1)
            XCTAssertEqual(presenter2.id, mockPresenter1.id)
            
        } else {
            XCTFail("There should be two RoutingObserverWrapper in there")
        }
        
    }
    
}
