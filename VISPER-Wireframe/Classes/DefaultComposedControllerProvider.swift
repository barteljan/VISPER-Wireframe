//
//  DefaultComposedControllerProvider.swift
//  VISPER-Wireframe
//
//  Created by bartel on 22.11.17.
//

import Foundation
import VISPER_Wireframe_Core

public class DefaultComposedControllerProvider : ComposedControllerProvider {
    
    
    var routingProviders: [ProviderWrapper]
    
    public init(){
        self.routingProviders = [ProviderWrapper]()
    }
    
    
    public func add(controllerProvider: ControllerProvider, priority: Int) {
        let wrapper = ProviderWrapper(priority: priority, controllerProvider: controllerProvider)
        self.addRoutingProviderWrapper(wrapper: wrapper)
    }
    
    public func controller(routeResult: RouteResult, routingOption: RoutingOption) -> UIViewController? {
        
        for wrapper in self.routingProviders {
            
            let controllerProvider = wrapper.controllerProvider
                
            if let viewController = controllerProvider.controller(routeResult: routeResult,
                                                                  routingOption: routingOption) {
                return viewController
            }
            
        }
        
        return nil
        
    }
    
    //MARK: some helper structs
    struct ProviderWrapper {
        let priority : Int
        let controllerProvider : ControllerProvider
    }
    
    //MARK: some helper functions
    func addRoutingProviderWrapper(wrapper: ProviderWrapper) {
        self.routingProviders.append(wrapper)
        self.routingProviders.sort { (wrapper1, wrapper2) -> Bool in
            return wrapper1.priority > wrapper2.priority
        }
    }
    
    
}
