//
//  WireframeObjc.swift
//  Pods-VISPER-Wireframe_Example
//
//  Created by Jan Bartel on 20.11.17.
//

import Foundation

@objc open class WireframeObjc : NSObject {
    
    public let wireframe : Wireframe
    
    public init(wireframe : Wireframe) {
        self.wireframe = wireframe
    }
    
    /// Check if a route pattern matching this url was added to the wireframe.
    /// Be careful, if you don't route to a handler (but to a controller),
    /// it's possible that no ControllerProvider or RoutingOptionProvider for this controller exists.
    ///
    /// - Parameters:
    ///   - url: the url to check for resolution
    ///   - parameters: the parameters (data) given to the controller
    /// - Returns: Can the wireframe find a route for the given url
    @objc open func canRoute(    url: URL,
                          parameters: [String : Any]) -> Bool {
        do {
            return try self.wireframe.canRoute(url: url, parameters: parameters)
        } catch let error {
            print("ERROR: \(error)")
            return false
        }
    }
    
   
    /// Route to a new route presenting a view controller
    ///
    /// - Parameters:
    ///   - url: the route of the view controller to be presented
    ///   - option: how should your view controller be presented
    ///   - parameters: a dictionary of parameters (data) send to the presented view controller
    ///   - completion: function called when the view controller was presented
    /// - Throws: throws an error when no controller and/or option provider can be found.
    @objc open func route(url: URL,
                       option: RoutingOptionObjc?,
                   parameters: [String : Any],
                   completion: @escaping () -> Void) throws {
        
        
        try self.wireframe.route(url: url,
                              option: option?.routingOption,
                          parameters: parameters,
                          completion: completion)
        
    }
    
    
    /// Return the view controller for a given url
    ///
    /// - Parameters:
    ///   - url: url
    ///   - parameters: parameters
    /// - Returns: nil if no controller was found, the found controller otherwise
    @objc open func controller(url: URL,
                        parameters: [String : Any]) -> UIViewController? {
        
        do {
            return try self.wireframe.controller(url: url,
                                          parameters: parameters)
        } catch let error {
            print("ERROR: \(error)")
            return nil
        }
    }
    
}

