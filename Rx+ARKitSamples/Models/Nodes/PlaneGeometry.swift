//
//  PlaneGeometry.swift
//  Rx+ARKitSamples
//
//  Created by 윤중현 on 09/10/2018.
//  Copyright © 2018 tokijh. All rights reserved.
//

import ARKit

class PlaneGeometry: SCNPlane {
    convenience init(name: String, contents: Any) {
        self.init(name: name)
        firstMaterial?.diffuse.contents = contents
    }
    
    init(name: String) {
        super.init()
        self.name = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
