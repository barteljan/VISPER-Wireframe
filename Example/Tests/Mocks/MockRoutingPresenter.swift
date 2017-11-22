//
//  MockRoutingPresenter.swift
//  VISPER-Wireframe_Tests
//
//  Created by bartel on 19.11.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import VISPER_Wireframe_Core


class MockRoutingPresenter: RoutingPresenter {

    var id : String?
    

    func isResponsible(option: RoutingOption) -> Bool {
        return true
    }

    func present(controller: UIViewController,
                 routePattern: String,
                 option: RoutingOption,
                 parameters: [String : Any],
                 wireframe: Wireframe,
                 delegate: RoutingPresenterDelegate,
                 completion: @escaping () -> ()) throws {}

    
}
