//
//  UICubicTimingParameters.swift
//  InteractiveDismissal
//
//  Created by Garric Nahapetian on 3/29/19.
//  Copyright © 2019 Tinder. All rights reserved.
//

import UIKit

public extension UICubicTimingParameters {

    /// This cubic bezier curve mimics that of `UIModalTransitionStyle.coverVertical`.
    static var coverVertical: UICubicTimingParameters {
        return UICubicTimingParameters(controlPoint1: CGPoint(x: 0.25, y: 1), controlPoint2: CGPoint(x: 0.25, y: 1))
    }
}
