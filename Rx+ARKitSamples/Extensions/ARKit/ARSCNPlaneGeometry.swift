//
//  ARSCNPlaneGeometry.swift
//  Rx+ARKitSamples
//
//  Created by 윤중현 on 09/10/2018.
//  Copyright © 2018 tokijh. All rights reserved.
//

import ARKit

@available(iOS 11.3, *)
extension ARSCNPlaneGeometry {
    convenience init?(name: String, device: MTLDevice, contents: Any) {
        self.init(name: name, device: device)
        firstMaterial?.diffuse.contents = contents
    }
    convenience init?(name: String, device: MTLDevice) {
        self.init(device: device)
        self.name = name
    }
}
