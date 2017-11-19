//
//  Wireframe.swift
//  Pods-SwiftyVISPER_Example
//
//  Created by bartel on 17.11.17.
//

import Foundation

public protocol Wireframe {
    
    /// Route to a new route presenting a view controller
    ///
    /// - Parameters:
    ///   - url: the route of the view controller to be presented
    ///   - option: how should your view controller be presented
    ///   - parameters: a dictionary of parameters (data) send to the presented view controller
    ///   - completion: function called when the view controller was presented
    /// - Throws: throws an error when no controller and/or option provider can be found.
    func route(url: URL,
               option: RoutingOption,
               parameters: [String : Any],
               completion: @escaping () -> Void) throws
    
    /// Can the wireframe resolve a given url
    ///
    /// - Parameters:
    ///   - url: the url to check for resolution
    ///   - parameters: the parameters (data) given to the controller
    /// - Returns: Can the wireframe find a route for the given url
    func canRoute(   url: URL,
              parameters: [String : Any]) -> Bool
    
    /// Register a route pattern for routing.
    /// You have to register a route pattern to allow the wireframe matching it.
    /// This is done automatically if you are using a ViewFeature from SwiftyVISPER as ControllerProvider.
    ///
    /// - Parameters:
    ///   - pattern: the route pattern to register
    func addRoutePattern(_ pattern: String)
    
    /// Register a route pattern and a handler
    /// The handler will be called if a route matches your route pattern.
    /// (you dont't have to add your pattern manually in this case)
    /// - Parameters:
    ///   - pattern: The route pattern for calling your handler
    ///   - priority: The priority for calling your handler, higher priorities are called first. (Defaults to 0)
    ///   - handler: A handler called when a route matches your route pattern
    func addRoutePattern(_ pattern: String,
                         priority: Int,
                         handler: @escaping (_ parameters: [String : Any]) -> Void )
    
    /// Return the view controller for a given url
    ///
    /// - Parameters:
    ///   - url: url
    ///   - parameters: parameters
    /// - Returns: nil if no controller was found, the found controller otherwise
    func controller(url: URL,
             parameters: [String : Any]) throws -> UIViewController?
    
    /// Add an instance providing a controller for a route
    ///
    /// - Parameters:
    ///   - controllerProvider: instance providing a controller
    ///   - priority: The priority for calling your provider, higher priorities are called first. (Defaults to 0)
    func add(controllerProvider: ControllerProvider, priority: Int)
    
    /// Add an instance providing routing options for a route
    ///
    /// - Parameters:
    ///   - optionProvider: instance providing routing options for a route
    ///   - priority: The priority for calling your provider, higher priorities are called first. (Defaults to 0)
    func add(optionProvider: RoutingOptionProvider, priority: Int)
    
    
    
    /// Add an instance observing controllers before they are presented
    ///
    /// - Parameters:
    ///   - routingObserver: An instance observing controllers before they are presented
    ///   - priority: The priority for calling your provider, higher priorities are called first. (Defaults to 0)
    func add(routingObserver: RoutingObserver, priority: Int)
    
    
    /// Add an instance responsible for presenting view controllers.
    /// It will be triggert after the wireframe resolves a route
    ///
    /// - Parameter routingPresenter: An instance responsible for presenting view controllers
    func add(routingPresenter: RoutingPresenter)
    
}
