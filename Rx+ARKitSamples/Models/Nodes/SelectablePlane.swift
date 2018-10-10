//
//  SelectablePlane.swift
//  Rx+ARKitSamples
//
//  Created by 윤중현 on 10/10/2018.
//  Copyright © 2018 tokijh. All rights reserved.
//

import ARKit

class SelectablePlane: Plane {
    
    convenience init(name: String, selectablePlaneGeometry: SelectablePlaneGeometry, anchor: ARPlaneAnchor) {
        self.init(name: name, planeGeometry: selectablePlaneGeometry, anchor: anchor)
    }
    
    convenience init(name: String, selectablePlaneGeometry: SelectablePlaneGeometry) {
        self.init(name: name, planeGeometry: selectablePlaneGeometry)
    }
    
    // MARK Update
    public override func update(anchor: ARPlaneAnchor) {
        super.update(anchor: anchor)
        guard let selectablePlaneGeometry = self.selectablePlaneGeometry else { return }
        selectablePlaneGeometry.update()
    }
    
    // MARK SelectablePlaneGeometry
    var selectablePlaneGeometry: SelectablePlaneGeometry? {
        return geometry as? SelectablePlaneGeometry
    }
    
    // MARK Selection
    var isSelected: Bool {
        get {
            return selectablePlaneGeometry?.isSelected ?? false
        }
        set {
            selectablePlaneGeometry?.isSelected = newValue
        }
    }
    
    public func updateSelection() {
        let isSelected = self.isSelected
        self.isSelected = isSelected
    }
    
    public func select() {
        isSelected = true
    }
    
    public func deselect() {
        isSelected = false
    }
    
    public func toggle() {
        isSelected ? deselect() : select()
    }
}

extension SCNNode {
    var selectableplanes: [SelectablePlane] {
        return childNodes.map({ $0 as? SelectablePlane }).compactMap({ $0 })
    }
}
