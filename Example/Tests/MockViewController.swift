//
//  MockViewController.swift
//  VISPER-Wireframe_Example
//
//  Created by Jan Bartel on 20.11.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import VISPER_Wireframe_UIViewController

class MockViewController : UIViewController {
    
    var validateDidCallWillRoute = false
    override func willRoute(_ wireframe: WireframeObjc!,
                                  routePattern: String!,
                                        option: RoutingOptionObjc!,
                                    parameters: [AnyHashable : Any]!) {
        validateDidCallWillRoute = true
    }
    
    
    var validateDidCallDidRoute = false
    override func didRoute(_ wireframe: WireframeObjc!,
                            routePattern: String!,
                            option: RoutingOptionObjc!,
                            parameters: [AnyHashable : Any]!) {
        validateDidCallDidRoute = true
    }
    
    
}
