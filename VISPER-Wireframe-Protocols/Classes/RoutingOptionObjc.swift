//
//  RoutingOptionObjc.swift
//  Pods-VISPER-Wireframe_Example
//
//  Created by Jan Bartel on 20.11.17.
//

import Foundation

@objc open class RoutingOptionObjc : NSObject {
    
    public let routingOption : RoutingOption
    
    public init(routingOption : RoutingOption){
        self.routingOption = routingOption
    }
    
    @objc public func typeString() -> String {
        return String(describing:type(of:self.routingOption))
    }
    
}
