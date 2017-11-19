//
//  VISPERWireframe.swift
//  Pods-SwiftyVISPER_Example
//
//  Created by bartel on 18.11.17.
//

import Foundation

internal struct RouteHandlerWrapper {
    
    let routePattern : String
    let handler : (([String : Any]) -> Void)

}

internal struct ProviderWrapper {
    
    let priority : Int
    let controllerProvider : ControllerProvider?
    let handlerWrapper : RouteHandlerWrapper?
    
}

internal struct OptionProviderWrapper {
    let priority : Int
    let optionProvider : RoutingOptionProvider
}

internal struct RoutingObserverWrapper {
    let priority : Int
    let routePattern : String?
    let routingObserver : RoutingObserver
}

internal struct RoutingPresenterWrapper {
    let priority : Int
    let routingPresenter : RoutingPresenter
}


open class DefaultWireframe : Wireframe {
   
    let router: Router
    
    var optionProviders: [OptionProviderWrapper] = [OptionProviderWrapper]()
    var routingProviders: [ProviderWrapper] = [ProviderWrapper]()
    var routingObservers: [RoutingObserverWrapper] = [RoutingObserverWrapper]()
    var routingPresenters: [RoutingPresenterWrapper] = [RoutingPresenterWrapper]()
    
    public init(router : Router = DefaultRouter()){
        self.router = router
    }
    
    open func route(url: URL, option: RoutingOption, parameters: [String : Any], completion: @escaping () -> Void) throws {
        fatalError("not yet implemented")
    }
    
    public func canRoute(url: URL, parameters: [String : Any]) -> Bool {
         fatalError("not yet implemented")
    }
    
    open func addRoutePattern(_ pattern: String) throws{
        try self.router.add(routePattern: pattern)
    }
    
    open func addRoutePattern(_ pattern: String, priority: Int = 0, handler: @escaping ([String : Any]) -> Void) throws {
        
        let handlerWrapper = RouteHandlerWrapper(routePattern: pattern,
                                                 handler: handler)
        
        let providerWrapper = ProviderWrapper(priority: priority,
                                    controllerProvider: nil,
                                        handlerWrapper: handlerWrapper)
        
        self.addRoutingProviderWrapper(wrapper: providerWrapper)
    }
    
    open func controller(url: URL, parameters: [String : Any]) -> UIViewController? {
        fatalError("not yet implemented")
    }
    
    open func add(controllerProvider: ControllerProvider, priority: Int = 0) {
        let providerWrapper = ProviderWrapper(priority: priority,
                                              controllerProvider: controllerProvider,
                                              handlerWrapper: nil)
        self.addRoutingProviderWrapper(wrapper: providerWrapper)
    }
    
    open func add(optionProvider: RoutingOptionProvider, priority: Int = 0) {
        let wrapper = OptionProviderWrapper(priority: priority, optionProvider: optionProvider)
        self.addOptionProviderWrapper(wrapper: wrapper)
    }
    
    open func add(routingObserver: RoutingObserver, priority: Int = 0, routePattern: String? = nil) {
        let wrapper = RoutingObserverWrapper(priority: priority, routePattern: routePattern, routingObserver: routingObserver)
        self.addRoutingObserverWrapper(wrapper: wrapper)
    }
    
    open func add(routingPresenter: RoutingPresenter,priority: Int = 0) {
        fatalError("not yet implemented")
    }
    
    func addRoutingProviderWrapper(wrapper: ProviderWrapper) {
        self.routingProviders.append(wrapper)
        self.routingProviders.sort { (wrapper1, wrapper2) -> Bool in
            return wrapper1.priority > wrapper2.priority
        }
    }
    
    func addOptionProviderWrapper(wrapper: OptionProviderWrapper) {
        self.optionProviders.append(wrapper)
        self.optionProviders.sort { (wrapper1, wrapper2) -> Bool in
            return wrapper1.priority > wrapper2.priority
        }
    }
    
    func addRoutingObserverWrapper(wrapper: RoutingObserverWrapper) {
        self.routingObservers.append(wrapper)
        self.routingObservers.sort { (wrapper1, wrapper2) -> Bool in
            return wrapper1.priority > wrapper2.priority
        }
    }
    
    func addRoutingPresenterWrapper(wrapper: RoutingObserverWrapper) {
        self.routingPresenters.append(wrapper)
        self.routingPresenters.sort { (wrapper1, wrapper2) -> Bool in
            return wrapper1.priority > wrapper2.priority
        }
    }
}
