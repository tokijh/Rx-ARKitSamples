//
//  MeshPlane.swift
//  Rx+ARKitSamples
//
//  Created by 윤중현 on 09/10/2018.
//  Copyright © 2018 tokijh. All rights reserved.
//

import ARKit

@available(iOS 11.3, *)
class MeshPlane: SCNNode {
    
    convenience init(name: String, planeGeometry: ARSCNPlaneGeometry, anchor: ARPlaneAnchor) {
        self.init(name: name, planeGeometry: planeGeometry)
        update(anchor: anchor)
    }
    
    convenience init(name: String, planeGeometry: ARSCNPlaneGeometry) {
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
        planeGeometry.update(from: anchor.geometry)
    }
    
    // MARK PlaneGeometry
    var planeGeometry: ARSCNPlaneGeometry? {
        return geometry as? ARSCNPlaneGeometry
    }
}

extension SCNNode {
    @available(iOS 11.3, *)
    var meshPlanes: [MeshPlane] {
        return childNodes.map({ $0 as? MeshPlane }).compactMap({ $0 })
    }
}
