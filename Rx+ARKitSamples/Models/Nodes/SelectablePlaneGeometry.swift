//
//  SelectablePlaneGeometry.swift
//  Rx+ARKitSamples
//
//  Created by 윤중현 on 10/10/2018.
//  Copyright © 2018 tokijh. All rights reserved.
//

import ARKit

class SelectablePlaneGeometry: SCNPlane {
    convenience init(name: String, contents: Any, selectedContents: Any, isSelected: Bool = false) {
        self.init(name: name)
        self.contents = contents
        self.selectedContents = selectedContents
        self.isSelected = isSelected
    }
    
    init(name: String) {
        super.init()
        self.name = name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func update() {
        updateSelection()
    }
    
    // MARK Selection
    var isSelected: Bool = false {
        didSet {
            if isShowSelector {
                firstMaterial?.diffuse.contents = isSelected ? selectedContents : contents
            } else {
                firstMaterial?.diffuse.contents = UIColor.clear
            }
        }
    }
    
    var isShowSelector: Bool = true {
        didSet {
            updateSelection()
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
    
    // MARK Contents
    var contents: Any? = nil {
        didSet {
            updateSelection()
        }
    }
    var selectedContents: Any? = nil {
        didSet {
            updateSelection()
        }
    }
}
