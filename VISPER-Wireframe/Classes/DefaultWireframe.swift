//
//  VISPERWireframe.swift
//  Pods-SwiftyVISPER_Example
//
//  Created by bartel on 18.11.17.
//

import Foundation

open class DefaultWireframe : Wireframe {
   
    let router : Router
    
    public init(router : Router = DefaultRouter()){
        self.router = router
    }
    
    open func route(url: URL, option: RoutingOption, parameters: [String : Any], completion: @escaping () -> Void) throws {
        fatalError("not yet implemented")
    }
    
    public func canRoute(url: URL, parameters: [String : Any]) -> Bool {
         fatalError("not yet implemented")
    }
    
    open func addRoutePattern(_ pattern: String) {
        fatalError("not yet implemented")
    }
    
    open func addRoutePattern(_ pattern: String, priority: Int, handler: @escaping ([String : Any]) -> Void) {
        fatalError("not yet implemented")
    }
    
    open func controller(url: URL, parameters: [String : Any]) -> UIViewController? {
        fatalError("not yet implemented")
    }
    
    open func add(controllerProvider: ControllerProvider, priority: Int) {
        fatalError("not yet implemented")
    }
    
    open func add(optionProvider: RoutingOptionProvider, priority: Int) {
        fatalError("not yet implemented")
    }
    
    open func add(routingObserver: RoutingObserver, priority: Int) {
        fatalError("not yet implemented")
    }
    
    open func add(routingPresenter: RoutingPresenter) {
        fatalError("not yet implemented")
    }
    
    
}
