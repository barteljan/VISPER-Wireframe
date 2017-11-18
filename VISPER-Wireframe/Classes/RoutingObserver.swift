//
//  RoutingObserver.swift
//  VISPER-Wireframe
//
//  Created by bartel on 18.11.17.
//

import Foundation

public protocol RoutingObserver {
    
    func willRoute(to controller: UIViewController,
                    routePattern: String,
                   routingOption: RoutingOption,
                      parameters: [String : Any],
                routingPresenter: RoutingPresenter,
                       wireframe: Wireframe)
    
}
