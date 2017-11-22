//
//  DefaultComposedRoutingProvider.swift
//  VISPER-Wireframe_Tests
//
//  Created by bartel on 21.11.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import XCTest
@testable import VISPER_Wireframe

class DefaultComposedRoutingOptionProviderTests: XCTestCase {
    
    func testAddRoutingOptionProvider() throws {
        
        let mockProvider = MockRoutingOptionProvider()
        
        let composedProvider = DefaultComposedRoutingOptionProvider()
        
        let priority = 10
        composedProvider.add(optionProvider: mockProvider, priority: priority)
        
        if composedProvider.optionProviders.count == 1 {
            
            let wrapper = composedProvider.optionProviders[0]
            
            guard let provider = wrapper.optionProvider as? MockRoutingOptionProvider else {
                XCTFail("wrapper should contain our routing option provider")
                return
            }
            
            XCTAssertEqual(wrapper.priority, priority)
            XCTAssertEqual(provider, mockProvider)
            
        } else {
            XCTFail("There should be one RoutingOptionWrapper in there")
        }
        
    }
    
    func testAddRoutingOptionProviderPriority() throws {
        
        
        let mockProvider1 = MockRoutingOptionProvider()
        let priority1 = 5
        
        let mockProvider2 = MockRoutingOptionProvider()
        let priority2 = 10
        
        let composedProvider = DefaultComposedRoutingOptionProvider()
        
        
        composedProvider.add(optionProvider: mockProvider1, priority: priority1)
        composedProvider.add(optionProvider: mockProvider2, priority: priority2)
        
        if composedProvider.optionProviders.count == 2 {
            
            let wrapper1 = composedProvider.optionProviders[0]
            guard let provider1 = wrapper1.optionProvider as? MockRoutingOptionProvider else {
                XCTFail("wrapper should contain our routing option provider")
                return
            }
            
            let wrapper2 = composedProvider.optionProviders[1]
            guard let provider2 = wrapper2.optionProvider as? MockRoutingOptionProvider else {
                XCTFail("wrapper should contain our routing option provider")
                return
            }
            
            XCTAssertEqual(wrapper1.priority, priority2)
            XCTAssertEqual(provider1, mockProvider2)
            
            XCTAssertEqual(wrapper2.priority, priority1)
            XCTAssertEqual(provider2, mockProvider1)
            
        } else {
            XCTFail("There should be two RoutingOptionWrapper in there")
        }
        
    }
    
    func testOptionReturnsCorrectOption() {
        
        let mockProvider = MockRoutingOptionProvider()
        let stubbedOption = MockRoutingOption()
        mockProvider.stubbedOptionResult = stubbedOption
        let priority = 10
        
        let composedProvider = DefaultComposedRoutingOptionProvider()
        
        
        composedProvider.add(optionProvider: mockProvider, priority: priority)
        
        
        guard let option = composedProvider.option(routePattern: "/some/pattern",
                                                     parameters: [:],
                                                  currentOption: MockRoutingOption()) as? MockRoutingOption else {
                                                        XCTFail()
                                                        return
        }
        
        XCTAssertTrue(mockProvider.invokedOption)
        XCTAssertEqual(option, stubbedOption)
    
    }
    
    func testOptionCallsChildProviders() {
        
        let mockProvider = MockRoutingOptionProvider()
        let priority = 10
        
        let composedProvider = DefaultComposedRoutingOptionProvider()
        
        
        composedProvider.add(optionProvider: mockProvider, priority: priority)
        
        
        let _ = composedProvider.option(routePattern: "/some/pattern",
                                          parameters: [:],
                                       currentOption: MockRoutingOption())
        
        XCTAssertTrue(mockProvider.invokedOption)
        
        
    }
    
    
    
    func testOptionCallsChildProviderWithCorrectParameters() {
        
        let mockProvider = MockRoutingOptionProvider()
        let priority = 10
        
        let composedProvider = DefaultComposedRoutingOptionProvider()
        
        composedProvider.add(optionProvider: mockProvider, priority: priority)
        
        let routePattern = "/some/pattern"
        let params = ["id" : "15"]
        let currentOption = MockRoutingOption()
        
        let _ = composedProvider.option(routePattern: routePattern,
                                             parameters: params,
                                             currentOption: currentOption)
        

        
        
        XCTAssertEqual(mockProvider.invokedOptionParameters?.routePattern, routePattern)
        XCTAssertNotNil(mockProvider.invokedOptionParameters?.parameters["id"])
        XCTAssertEqual(mockProvider.invokedOptionParameters?.parameters["id"] as? String, params["id"])
        
        guard let invokedOption = mockProvider.invokedOptionParameters?.currentOption as? MockRoutingOption else {
            XCTFail()
            return
        }
        XCTAssertEqual(invokedOption, currentOption)

    }
    
    
    func testOptionCallsHighPriorityProviderLast() throws {
        
        let firstCalledProvider = MockRoutingOptionProvider()
        let firstCalledOption = MockRoutingOption()
        firstCalledProvider.stubbedOptionResult = firstCalledOption
        let firstCalledPriority = 5
        
        let secondCalledProvider = MockRoutingOptionProvider()
        let secondCalledOption = MockRoutingOption()
        secondCalledProvider.stubbedOptionResult = secondCalledOption
        let secondCalledPriority = 10
        
        let lastCalledProvider = MockRoutingOptionProvider()
        let lastCalledOption = MockRoutingOption()
        lastCalledProvider.stubbedOptionResult = lastCalledOption
        let lastCalledPriority = 15
        
        let composedProvider = DefaultComposedRoutingOptionProvider()
        
        composedProvider.add(optionProvider: secondCalledProvider, priority: secondCalledPriority)
        composedProvider.add(optionProvider: lastCalledProvider, priority: lastCalledPriority)
        composedProvider.add(optionProvider: firstCalledProvider, priority: firstCalledPriority)
        
        let _ = composedProvider.option(routePattern: "/some/pattern",
                                          parameters: [:],
                                       currentOption: nil)
        
        
        guard let firstCall = firstCalledProvider.invokedOptionTime?.timeIntervalSince1970 else {
            XCTFail()
            return
        }
        
        guard let secondCall = secondCalledProvider.invokedOptionTime?.timeIntervalSince1970 else {
            XCTFail()
            return
        }
        
        guard let lastCall = lastCalledProvider.invokedOptionTime?.timeIntervalSince1970 else {
            XCTFail()
            return
        }
        
        XCTAssertTrue(firstCall < secondCall)
        XCTAssertTrue(firstCall < lastCall)
        XCTAssertTrue(secondCall < lastCall)
        
    }
    
    func testOptionReturnsHighestOption() throws {
        
        let firstCalledProvider = MockRoutingOptionProvider()
        let firstCalledOption = MockRoutingOption()
        firstCalledProvider.stubbedOptionResult = firstCalledOption
        let firstCalledPriority = 5
        
        let secondCalledProvider = MockRoutingOptionProvider()
        let secondCalledOption = MockRoutingOption()
        secondCalledProvider.stubbedOptionResult = secondCalledOption
        let secondCalledPriority = 10
        
        let lastCalledProvider = MockRoutingOptionProvider()
        let lastCalledOption = MockRoutingOption()
        lastCalledProvider.stubbedOptionResult = lastCalledOption
        let lastCalledPriority = 15
        
        let composedProvider = DefaultComposedRoutingOptionProvider()
        
        composedProvider.add(optionProvider: secondCalledProvider, priority: secondCalledPriority)
        composedProvider.add(optionProvider: lastCalledProvider, priority: lastCalledPriority)
        composedProvider.add(optionProvider: firstCalledProvider, priority: firstCalledPriority)
        
        guard let resultOption = composedProvider.option(routePattern: "/some/pattern",
                                                         parameters: [:],
                                                         currentOption: nil) as? MockRoutingOption else {
                                                            XCTFail()
                                                            return
        }
        
        XCTAssertEqual(resultOption, lastCalledOption)
        
    }
    
    func testFirstOptionIsCurrentOptionForSecondProvider() {
        
        let firstCalledProvider = MockRoutingOptionProvider()
        let firstCalledOption = MockRoutingOption()
        firstCalledProvider.stubbedOptionResult = firstCalledOption
        let firstCalledPriority = 5
        
        let secondCalledProvider = MockRoutingOptionProvider()
        let secondCalledOption = MockRoutingOption()
        secondCalledProvider.stubbedOptionResult = secondCalledOption
        let secondCalledPriority = 10
        

        let composedProvider = DefaultComposedRoutingOptionProvider()
        
        composedProvider.add(optionProvider: secondCalledProvider, priority: secondCalledPriority)
        composedProvider.add(optionProvider: firstCalledProvider, priority: firstCalledPriority)
        
        let _ = composedProvider.option(routePattern: "/some/pattern",
                                          parameters: [:],
                                       currentOption: nil)
        
        
        guard let currentOptionInvokingSecondProvider = secondCalledProvider.invokedOptionParameters?.currentOption as? MockRoutingOption else {
            XCTFail()
            return
        }
        XCTAssertEqual(currentOptionInvokingSecondProvider, firstCalledOption)
        
    }
    
    
}

