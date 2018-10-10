//
//  BorderedPlaneGeometry.swift
//  Rx+ARKitSamples
//
//  Created by 윤중현 on 10/10/2018.
//  Copyright © 2018 tokijh. All rights reserved.
//

import ARKit

class BorderedPlaneGeometry: PlaneGeometry {
    convenience init(name: String, contents: Any) {
        self.init(name: name)
        guard let path = Bundle.main.path(forResource: "wireframe_shader", ofType: "metal", inDirectory: "Assets.scnassets")
            else { fatalError("Can't find wireframe shader") }
        do {
            let shader = try String(contentsOfFile: path, encoding: .utf8)
            firstMaterial?.shaderModifiers = [.surface: shader]
        } catch {
            fatalError("Can't load wireframe shader: \(error)")
        }
    }
    
    override init(name: String) {
        super.init(name: name)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
