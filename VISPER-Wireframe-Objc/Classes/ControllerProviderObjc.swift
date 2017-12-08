//
//  ControllerProviderObjc.swift
//  VISPER-Wireframe-Objc
//
//  Created by bartel on 08.12.17.
//

import Foundation
import VISPER_Wireframe_Core

@objc public protocol ControllerProviderObjcType {
    
    func isResponsible(routeResult: RouteResultObjc) -> Bool
    func makeController(routeResult: RouteResultObjc) throws -> UIViewController
    
}

@objc open class ControllerProviderObjc : NSObject,ControllerProvider,ControllerProviderObjcType{
   
    open let controllerProvider : ControllerProvider?
    open let controllerProviderObjc : ControllerProviderObjcType?
    
    public init(controllerProvider : ControllerProvider) {
        self.controllerProvider = controllerProvider
        self.controllerProviderObjc = nil
        super.init()
    }
    
    @objc public init(controllerProvider : ControllerProviderObjcType) {
        self.controllerProviderObjc = controllerProvider
        self.controllerProvider = nil
        super.init()
    }
    
    
    open func isResponsible(routeResult: RouteResult) -> Bool {
        
        guard controllerProvider != nil || controllerProviderObjc != nil else {
            fatalError("there should be a controllerProvider or a controllerProviderObjc")
        }
        
        if let controllerProvider = self.controllerProvider {
            return controllerProvider.isResponsible(routeResult: routeResult)
        } else if let controllerProviderObjC = self.controllerProviderObjc {
            let routeResultObjC = ObjcWrapper.wrapperProvider.routeResult(routeResult: routeResult)
            return controllerProviderObjC.isResponsible(routeResult: routeResultObjC)
        }
        
        return false
        
    }
    
    @objc open func isResponsible(routeResult: RouteResultObjc) -> Bool {
        
        guard controllerProvider != nil || controllerProviderObjc != nil else {
            fatalError("there should be a controllerProvider or a controllerProviderObjc")
        }
        
        if let controllerProvider = self.controllerProvider {
            return controllerProvider.isResponsible(routeResult: routeResult)
        } else if let controllerProviderObjC = self.controllerProviderObjc {
            return controllerProviderObjC.isResponsible(routeResult: routeResult)
        }
        
        return false
        
    }
    
    public func makeController(routeResult: RouteResult) throws -> UIViewController {
        
        guard controllerProvider != nil || controllerProviderObjc != nil else {
            fatalError("there should be a controllerProvider or a controllerProviderObjc")
        }
        
        if let controllerProvider = self.controllerProvider {
            return try controllerProvider.makeController(routeResult:routeResult)
        } else if let controllerProviderObjC = self.controllerProviderObjc {
            let routeResultObjC = ObjcWrapper.wrapperProvider.routeResult(routeResult: routeResult)
            return try controllerProviderObjC.makeController(routeResult: routeResultObjC)
        }
        
        fatalError("there should be a controllerProvider or a controllerProviderObjc")
    }
    
    open func makeController(routeResult: RouteResultObjc) throws -> UIViewController {
        
        guard controllerProvider != nil || controllerProviderObjc != nil else {
            fatalError("there should be a controllerProvider or a controllerProviderObjc")
        }
        
        if let controllerProvider = self.controllerProvider {
            return try controllerProvider.makeController(routeResult:routeResult)
        } else if let controllerProviderObjC = self.controllerProviderObjc {
            return try controllerProviderObjC.makeController(routeResult: routeResult)
        }
        
        fatalError("there should be a controllerProvider or a controllerProviderObjc")
    }
    
}
