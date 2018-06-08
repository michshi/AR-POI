//
//  FloatingPoint+Extension.swift
//  AR-POI
//
//  Created by Michael Shields on 6/7/18.
//  Copyright © 2018 Inorganik Produce, Inc. All rights reserved.
//

import Foundation

extension FloatingPoint {
    func toRadians() -> Self {
        return self * .pi / 180
    }
    
    func toDegrees() -> Self {
        return self * 180 / .pi
    }
}
