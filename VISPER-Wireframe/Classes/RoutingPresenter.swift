//
//  RoutingPresenter.swift
//  VISPER-Wireframe
//
//  Created by bartel on 18.11.17.
//

import Foundation

public protocol RoutingPresenter {
    
    func isResponsible(option: RoutingOption) -> Bool
    
    func present(controller: UIViewController,
               routePattern: String,
                     option: RoutingOption,
                 parameters: [String : Any],
                  wireframe: Wireframe,
                 completion: (_ controller: UIViewController,
                              _ routePattern: String,
                              _ option: RoutingOption,
                              _ parameters: [String : Any],
                              _ wireframe: Wireframe) -> Void)
}
