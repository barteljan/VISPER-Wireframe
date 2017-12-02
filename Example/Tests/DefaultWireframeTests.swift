//
//  DefaultRouterRoutingTests.swift
//  VISPER-Wireframe_Tests
//
//  Created by bartel on 21.11.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import VISPER_Wireframe
import VISPER_Wireframe_Core

class DefaultWireframeTests: XCTestCase {
    
    func testAddsRoutePatternToRouter() throws {
        
        //Arrange
        let router = MockRouter()
        let wireframe = DefaultWireframe(router: router)
        
        let pattern = "/das/ist/ein/pattern"
        
        //Act
        try wireframe.add(routePattern:pattern)
       
        //Assert
        XCTAssert(router.invokedAdd)
        XCTAssertEqual(router.invokedAddParameters?.routePattern, pattern)
        
    }
    
    func testAddRoutingOptionProviderCallsComposedOptionProvider() throws {
        
        //Arrange
        let mockProvider = MockRoutingOptionProvider()
        
        let composedRoutingOptionProvider = MockComposedOptionProvider()
        let wireframe = DefaultWireframe(composedOptionProvider: composedRoutingOptionProvider)
        
        let priority = 10
        
        //Act
        wireframe.add(optionProvider: mockProvider, priority: priority)
        
        //Assert
        AssertThat(composedRoutingOptionProvider.invokedAddParameters?.optionProvider, isOfType: MockRoutingOptionProvider.self, andEquals: mockProvider)
        
    }
    
    func testAddHandlerCallsHandlerContainer(){
        
        //Arrange
        let container = MockRoutingHandlerContainer()
        let wireframe = DefaultWireframe(routingHandlerContainer: container)
        let routeResult = DefaultRouteResult(routePattern: "/some/pattern", parameters: [:])
        
        var didCallResponsibleHandler = false
        let responsibleHandler = { (routeResult: RouteResult) -> Bool in
            didCallResponsibleHandler = true
            return true
        }
        
        var didCallHandler = false
        let handler = {  (routeResult: RouteResult) -> Void in
            didCallHandler = true
        }
        
        let priority = 42
        
        //Act
        XCTAssertNoThrow(try wireframe.add(priority: priority, responsibleFor: responsibleHandler, handler: handler))
        
        
        //Assert
        XCTAssertTrue(container.invokedAdd)
        XCTAssertEqual(container.invokedAddParameters?.priority, priority)
        
        guard let responsibleHandlerParam = container.invokedAddResponsibleForParam else {
            XCTFail("responsibleHandler was not forwarded to handler container")
            return
        }
        
        XCTAssertFalse(didCallResponsibleHandler)
        _ = responsibleHandlerParam(routeResult)
        XCTAssertTrue(didCallResponsibleHandler)
        
        guard let handlerParam = container.invokedAddHandlerParam else {
            XCTFail("handler was not forwarded to handler container")
            return
        }
        
        XCTAssertFalse(didCallHandler)
        handlerParam(routeResult)
        XCTAssertTrue(didCallHandler)
        
    }
    
    func testCallsRouterOnRoute() {
        
        //Arrange
        let router = MockRouter()
        let wireframe = DefaultWireframe(router: router)
        
        let url = URL(string: "/a/nice/path")!
        let parameters = ["id" : "42"]
        let option = MockRoutingOption()
        
        //Act
        //throws error since mock router does not give a result
        XCTAssertThrowsError(try wireframe.route(url: url,
                                                 parameters: parameters,
                                                 option: option,
                                                 completion: {}))
        
        //Assert
        XCTAssertTrue(router.invokedRouteUrlRoutingOptionParameters)
        XCTAssertEqual(router.invokedRouteUrlRoutingOptionParametersParameters?.url, url)
        
        let invokedParams = NSDictionary(dictionary:(router.invokedRouteUrlRoutingOptionParametersParameters?.parameters)!)
        XCTAssertEqual(invokedParams, NSDictionary(dictionary:parameters))
        
        AssertThat(router.invokedRouteUrlRoutingOptionParametersParameters?.routingOption,
                        isOfType: MockRoutingOption.self,
                       andEquals: option)
        
    }
    
    func testRouteThrowsErrorWhenNoRoutePatternWasFound() {
        
        //Arrange
        let router = MockRouter()
        let wireframe = DefaultWireframe(router: router)
        
        let url = URL(string: "/a/nice/path")!
        let parameters = ["id" : "42"]
        let option = MockRoutingOption()
        
        //Act + Assert
        //throws error since mock router does not give a result
        XCTAssertThrowsError(try wireframe.route(url: url,
                                                 parameters: parameters,
                                                 option: option,
                                                 completion: {}),
                             "should throw DefaultWireframeError.noRoutePatternFoundFor") { error in
                                
                                switch error {
                                case DefaultWireframeError.noRoutePatternFoundFor(let errorUrl, let errorParameters):
                                    XCTAssertEqual(errorUrl, url)
                                    XCTAssertEqual(NSDictionary(dictionary: errorParameters), NSDictionary(dictionary:parameters))
                                default:
                                  XCTFail("should throw DefaultWireframeError.noRoutePatternFoundFor")
                                }
                
        }
        
        
    }
    
    
    func testCallsComposedRoutingOptionProviderWithRoutersRoutingResult() {
        
        //Arrange
        let router = MockRouter()
        let url = URL(string: "/a/nice/path")!
        let parameters = ["id" : "42"]
        let option = MockRoutingOption()
        
        let stubbedRouteResult = DefaultRouteResult(routePattern: "/a/nice/path",
                                                      parameters: parameters,
                                                   routingOption: option)
        router.stubbedRouteUrlRoutingOptionParametersResult = stubbedRouteResult
        
        let composedOptionProvider = MockComposedOptionProvider()
        
        let wireframe = DefaultWireframe(router: router,composedOptionProvider:composedOptionProvider)
        
        
        //Act
        //throws error since no controller can be provided afterwards, not important for this test
        XCTAssertThrowsError(try wireframe.route(url: url,
                                          parameters: parameters,
                                              option: option,
                                          completion: {}))
        
        //Assert
        XCTAssertTrue(composedOptionProvider.invokedOption)
        AssertThat(composedOptionProvider.invokedOptionParameters?.routeResult, isOfType: DefaultRouteResult.self, andEquals: stubbedRouteResult)
        
    }
    
    func testModifiesOptionByComposedRoutingObserver() {
        
        //Arrange
        let router = MockRouter()
        let url = URL(string: "/a/nice/path")!
        let parameters = ["id" : "42"]
        let option = MockRoutingOption()
        
        let stubbedRouteResult = DefaultRouteResult(routePattern: "/a/nice/path",
                                                    parameters: parameters,
                                                    routingOption: option)
        router.stubbedRouteUrlRoutingOptionParametersResult = stubbedRouteResult
        
        let composedOptionProvider = MockComposedOptionProvider()
        let optionProvidersOption = MockRoutingOption()
        composedOptionProvider.stubbedOptionResult = optionProvidersOption
        
        let wireframe = DefaultWireframe(router: router,composedOptionProvider:composedOptionProvider)
        
        
        // Act
        // throws error since no controller can be provided
        // the error should contain our modified routing option,
        // since it is called after modifing the route result by our option providers
        XCTAssertThrowsError(try wireframe.route(url: url,
                                                 parameters: parameters,
                                                 option: option,
                                                 completion: {}),
                             "should throw DefaultWireframeError.canNotHandleRoute ") { error in
                                
                                switch error {
                                case DefaultWireframeError.canNotHandleRoute(let result):
                                    
                                    //Assert
                                    AssertThat(result.routingOption, isOfType: MockRoutingOption.self, andEquals: optionProvidersOption)
                                default:
                                    XCTFail("should throw DefaultWireframeError.canNotHandleRoute")
                                }
        }
        
    }
    
    func testWireframeCallsHandler() {
        
        //Arrange
        
        //configure router to return a result
        let router = MockRouter()
        
        let stubbedRouteResult = DefaultRouteResult(routePattern: "/a/nice/path",
                                                    parameters: [:],
                                                    routingOption: MockRoutingOption())
        router.stubbedRouteUrlRoutingOptionParametersResult = stubbedRouteResult
        
        //configure handler container to return a handler and a priority
        let handlerContainer = MockRoutingHandlerContainer()
        
        var didCallHandler = false
        var handlerResult : RouteResult?
        let handler = {  (routeResult: RouteResult) -> Void in
            handlerResult = routeResult
            didCallHandler = true
        }
        handlerContainer.stubbedHandlerResult = handler
        handlerContainer.stubbedPriorityOfHighestResponsibleProviderResult = 42
        
        //create wireframe with mock dependencies
        let wireframe = DefaultWireframe(router: router,routingHandlerContainer: handlerContainer)
        
        var didCallCompletion = false
        let completion = {
            didCallCompletion = true
        }
        
        //Act
        XCTAssertNoThrow(try wireframe.route(url: URL(string: stubbedRouteResult.routePattern)!,
                                      parameters: stubbedRouteResult.parameters,
                                          option: stubbedRouteResult.routingOption!,
                                          completion: completion))
        
        //Assert
        XCTAssertTrue(didCallHandler)
        XCTAssertTrue(didCallCompletion)
        
        guard let routeResult = handlerResult else {
            XCTFail("since the handler should be called there should be a result")
            return
        }
        
        XCTAssertTrue(routeResult.isEqual(routeResult: stubbedRouteResult))
        
    }
    
    func testGetController() {
        //XCTFail("implement me")
    }
    
    
    
}

