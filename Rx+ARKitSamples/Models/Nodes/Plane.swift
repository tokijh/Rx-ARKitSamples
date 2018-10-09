//
//  Plane.swift
//  Rx+ARKitSamples
//
//  Created by 윤중현 on 09/10/2018.
//  Copyright © 2018 tokijh. All rights reserved.
//

import ARKit

class Plane: SCNNode {
    
    convenience init(name: String, planeGeometry: SCNPlane, anchor: ARPlaneAnchor) {
        self.init(name: name, planeGeometry: planeGeometry)
        update(anchor: anchor)
    }
    
    convenience init(name: String, planeGeometry: SCNPlane) {
        self.init(name: name)
        geometry = planeGeometry
    }
    
    init(name: String) {
        super.init()
        self.name = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK Update
    public func update(anchor: ARPlaneAnchor) {
        guard let planeGeometry = self.planeGeometry else { return }
        planeGeometry.update(extent: anchor.extent)
        simdPosition = anchor.center
        eulerAngles.x = -.pi / 2
    }
    
    // MARK PlaneGeometry
    var planeGeometry: SCNPlane? {
        return geometry as? SCNPlane
    }
}

extension SCNNode {
    var planes: [Plane] {
        return childNodes.map({ $0 as? Plane }).compactMap({ $0 })
    }
}
