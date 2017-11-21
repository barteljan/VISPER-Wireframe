//
//  DefaultComposedRoutingPresenter.swift
//  VISPER-Wireframe
//
//  Created by bartel on 21.11.17.
//

import Foundation
import VISPER_Wireframe_Core

open class DefaultComposedRoutingPresenter : ComposedRoutingPresenter {
    
    let composedRoutingObserver : ComposedRoutingObserver
    var routingPresenters: [RoutingPresenterWrapper]
    
    
    public init(composedRoutingObserver : ComposedRoutingObserver = DefaultComposedRoutingObserver()){
        self.composedRoutingObserver = composedRoutingObserver
        self.routingPresenters = [RoutingPresenterWrapper]()
    }
    
    /// Add an instance observing controllers before they are presented
    ///
    /// - Parameters:
    ///   - routingObserver: An instance observing controllers before they are presented
    ///   - priority: The priority for calling your provider, higher priorities are called first. (Defaults to 0)
    ///   - routePattern: The route pattern to call this observer, the observer is called for every route if this pattern is nil
    public func add(routingObserver: RoutingObserver, priority: Int, routePattern: String?) {
        self.composedRoutingObserver.add(routingObserver: routingObserver, priority: priority, routePattern: routePattern)
    }
    
    /// Add an instance responsible for presenting view controllers.
    /// It will be triggert after the wireframe resolves a route
    ///
    /// - Parameters:
    ///    - routingPresenter: An instance responsible for presenting view controllers
    ///    - priority: The priority for calling your provider, higher priorities are called first. (Defaults to 0)
    public func add(routingPresenter: RoutingPresenter, priority: Int) {
        let wrapper = RoutingPresenterWrapper(priority: priority, routingPresenter: routingPresenter)
        self.addRoutingPresenterWrapper(wrapper: wrapper)
    }
    
    /// Is this presenter responsible for presenting a given routing option
    ///
    /// - Parameter option: a given routing option
    /// - Returns: true if it is responsible, false if not
    public func isResponsible(option: RoutingOption) -> Bool {
        
        for wrapper in self.routingPresenters {
            if wrapper.routingPresenter.isResponsible(option: option) {
                return true
            }
        }
        return false
        
    }
    
    /// Present a view controller
    ///
    /// - Parameters:
    ///   - controller: The controller to be presented
    ///   - routePattern: The route pattern triggering this respresentation
    ///   - option: The routing option containing all presentation specific data
    ///   - parameters: The parameters (data) extraced from the route, or given by the sender
    ///   - wireframe: The wireframe triggering the presenter
    ///   - completion: a completion called after presentation has occured
    public func present(controller: UIViewController,
                      routePattern: String,
                            option: RoutingOption,
                        parameters: [String : Any],
                         wireframe: Wireframe,
                        completion: (UIViewController, String, RoutingOption, [String : Any], Wireframe) -> Void) throws {
        
        for routingPresenterWrapper in self.routingPresenters {
            
            if routingPresenterWrapper.routingPresenter.isResponsible(option: option) {
                
                //notify all responsible routing observers that the presentation will occour soon
                
                try self.composedRoutingObserver.willPresent(controller: controller,
                                                           routePattern: routePattern,
                                                          routingOption: option,
                                                             parameters: parameters,
                                                       routingPresenter: routingPresenterWrapper.routingPresenter,
                                                              wireframe: wireframe)
                
                
                
                //notify per objective c category
                let wireframeObjc = WireframeObjc(wireframe: wireframe)
                let routingOptionObjc = RoutingOptionObjc(routingOption: option)
                
                controller.willRoute(wireframeObjc,
                                      routePattern: routePattern,
                                      option: routingOptionObjc,
                                  parameters: parameters)
                
                //notify vc if it should be aware of it
                if let viewController = controller as? RoutingAwareViewController {
                    viewController.willRoute(wireframe: wireframe, routePattern: routePattern, option: option, parameters: parameters)
                }
                
                try routingPresenterWrapper.routingPresenter.present(controller: controller,
                                                                   routePattern: routePattern,
                                                                         option: option,
                                                                     parameters: parameters,
                                                                      wireframe: wireframe,
                                                                     completion: { (viewController, routePattern, option, parameters, wireframe) in
                                                                    
                                                                        completion(controller, routePattern, option, parameters, wireframe)
                                                                        
                                                                        //notify per objective c category
                                                                        viewController.didRoute(wireframeObjc,
                                                                                                routePattern: routePattern,
                                                                                                option: routingOptionObjc,
                                                                                                parameters: parameters)
                                                                        
                                                                        
                                                                        //notify vc if it should be aware of it
                                                                        if let viewController = viewController as? RoutingAwareViewController {
                                                                            viewController.didRoute(wireframe: wireframe,
                                                                                                    routePattern: routePattern,
                                                                                                    option: option, parameters: parameters)
                                                                        }
                                                                    
                })
                return
            }
            
        }
        
    }
    
    internal struct RoutingPresenterWrapper {
        let priority : Int
        let routingPresenter : RoutingPresenter
    }
    
    func addRoutingPresenterWrapper(wrapper: RoutingPresenterWrapper) {
        self.routingPresenters.append(wrapper)
        self.routingPresenters.sort { (wrapper1, wrapper2) -> Bool in
            return wrapper1.priority > wrapper2.priority
        }
    }
    
}
