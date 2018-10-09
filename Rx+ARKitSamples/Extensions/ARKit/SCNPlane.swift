//
//  SCNPlane.swift
//  Rx+ARKitSamples
//
//  Created by 윤중현 on 09/10/2018.
//  Copyright © 2018 tokijh. All rights reserved.
//

import SceneKit

extension SCNPlane {
    func update(extent: simd_float3) {
        width = CGFloat(extent.x)
        height = CGFloat(extent.z)
    }
}
