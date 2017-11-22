//
//  DefaultRoutingPresenterDelegate.swift
//  Pods-VISPER-Wireframe_Example
//
//  Created by bartel on 22.11.17.
//

import Foundation
import VISPER_Wireframe_Core

open class DefaultRoutingPresenterDelegate : RoutingPresenterDelegate {
    
    
    let composedRoutingObserver : ComposedRoutingObserver
    
    public init(composedRoutingObserver : ComposedRoutingObserver = DefaultComposedRoutingObserver()) {
        self.composedRoutingObserver = composedRoutingObserver
    }
    
    /// Add an instance observing controllers before they are presented
    ///
    /// - Parameters:
    ///   - routingObserver: An instance observing controllers before they are presented
    ///   - priority: The priority for calling your provider, higher priorities are called first. (Defaults to 0)
    ///   - routePattern: The route pattern to call this observer, the observer is called for every route if this pattern is nil
    func add(routingObserver: RoutingObserver, priority: Int, routePattern: String?){
        self.composedRoutingObserver.add(routingObserver: routingObserver,
                                                priority: priority,
                                            routePattern: routePattern)
    }
    
    
    /// Event that indicates that a view controller will be presented
    ///
    /// - Parameters:
    ///   - controller: The view controller that will be presented
    ///   - routePattern: The route pattern triggering the presentation
    ///   - routingOption: The RoutingOption describing how the controller will be presented
    ///   - parameters: The parameters (data) extraced from the route, or given by the sender
    ///   - routingPresenter: The RoutingPresenter responsible for presenting the controller
    ///   - wireframe: The wireframe presenting the view controller
    open func willPresent(controller: UIViewController,
                        routePattern: String,
                       routingOption: RoutingOption,
                          parameters: [String : Any],
                    routingPresenter: RoutingPresenter?, wireframe: Wireframe) throws {
        
        try self.composedRoutingObserver.willPresent(controller: controller,
                                                     routePattern: routePattern,
                                                     routingOption: routingOption,
                                                     parameters: parameters,
                                                     routingPresenter: routingPresenter,
                                                     wireframe: wireframe)
        
        
        
        //notify per objective c category
        let wireframeObjc = WireframeObjc(wireframe: wireframe)
        let routingOptionObjc = RoutingOptionObjc(routingOption: routingOption)
        
        controller.willRoute(wireframeObjc,
                             routePattern: routePattern,
                             option: routingOptionObjc,
                             parameters: parameters)
        
        //notify vc if it should be aware of it
        if let viewController = controller as? RoutingAwareViewController {
            viewController.willRoute(wireframe: wireframe,
                                  routePattern: routePattern,
                                        option: routingOption,
                                    parameters: parameters)
        }
        
    }
    
    /// Event that indicates that a view controller was presented
    ///
    /// - Parameters:
    ///   - controller: The view controller that will be presented
    ///   - routePattern: The route pattern triggering the presentation
    ///   - routingOption: The RoutingOption describing how the controller will be presented
    ///   - parameters: The parameters (data) extraced from the route, or given by the sender
    ///   - routingPresenter: The RoutingPresenter responsible for presenting the controller
    ///   - wireframe: The wireframe presenting the view controller
    open func didPresent(controller: UIViewController,
                       routePattern: String,
                      routingOption: RoutingOption,
                         parameters: [String : Any],
                   routingPresenter: RoutingPresenter?,
                          wireframe: Wireframe) {
        
        
        let routingOptionObjc = RoutingOptionObjc(routingOption: routingOption)
        let wireframeObjc = WireframeObjc(wireframe: wireframe)
        //notify per objective c category
        controller.didRoute(wireframeObjc, routePattern: routePattern,
                                                 option: routingOptionObjc,
                                             parameters: parameters)
        
        
        //notify vc if it should be aware of it
        if let viewController = controller as? RoutingAwareViewController {
            viewController.didRoute(wireframe: wireframe,
                                 routePattern: routePattern,
                                       option: routingOption,
                                   parameters: parameters)
        }
        
        
        self.composedRoutingObserver.didPresent(controller: controller,
                                              routePattern: routePattern,
                                             routingOption: routingOption,
                                                parameters: parameters,
                                          routingPresenter: routingPresenter,
                                                 wireframe: wireframe)
        
    }
    
}
