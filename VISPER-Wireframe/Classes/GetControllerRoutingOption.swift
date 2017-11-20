//
//  GetControllerRoutingOption.swift
//  VISPER-Wireframe
//
//  Created by bartel on 19.11.17.
//

import Foundation
import VISPER_Wireframe_Protocols

public protocol GetControllerRoutingOption : RoutingOption{
    
}

public struct DefaultGetControllerRoutingOption : GetControllerRoutingOption {
    public init(){}
}
