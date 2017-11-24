//
//  AssertHelper.swift
//  VISPER-Wireframe_Tests
//
//  Created by bartel on 23.11.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import XCTest

func AssertThat(time1: Date?, isEarlierThan time2: Date?) {
    
    guard let time1 = time1 else {
        XCTFail("time1 should not be nil")
        return
    }
    
    guard let time2 = time2 else {
        XCTFail("time2 should not be nil")
        return
    }
    
    XCTAssert(time1.timeIntervalSince1970 < time2.timeIntervalSince1970)
    
}
