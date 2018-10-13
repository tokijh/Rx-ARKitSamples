//
//  VideoPlayerSystem.swift
//  Rx+ARKitSamples
//
//  Created by 윤중현 on 11/10/2018.
//  Copyright © 2018 tokijh. All rights reserved.
//

import ARKit
import RxSwift
import RxCocoa

class VideoPlayerSystem {
    
    init() {
        setup()
    }
    
    private func setup() {
        setupFoundPlanes()
        setupSelectedPlane()
    }
    
    // MARK DisposeBag
    var disposeBag = DisposeBag()
    
    // MARK Status
    enum Status {
        case selectPlane
        case resizePlane
        case showVideo
    }
    
    let status = BehaviorRelay<Status>(value: .selectPlane)
    
    // MARK Planes
    let foundPlanes = BehaviorRelay<[SelectablePlane]>(value: [])
    
    private func setupFoundPlanes() {
        status
            .distinctUntilChanged()
            .filter({ $0 != .selectPlane })
            .withLatestFrom(foundPlanes)
            .filter({ $0.count > 0 })
            .withLatestFrom(selectedPlane) { (foundPlanes, selectedPlane) -> [SelectablePlane] in
                foundPlanes.filter({ $0 != selectedPlane })
            }
            .do(onNext: { $0.forEach({ $0.parent?.removeFromParentNode() }) })
            .map({ _ in [] })
            .bind(to: foundPlanes)
            .disposed(by: disposeBag)
    }
    
    private func addFound(plane: SelectablePlane) {
        var foundPlanes = self.foundPlanes.value
        guard !foundPlanes.contains(plane) else { return }
        foundPlanes.append(plane)
        self.foundPlanes.accept(foundPlanes)
    }
    
    private func removeFound(plane: SelectablePlane) {
        let foundPlanes = self.foundPlanes.value.filter({ $0 != plane })
        self.foundPlanes.accept(foundPlanes)
    }
    
    // MARK Selected Plane
    let selectedPlane = BehaviorRelay<SelectablePlane?>(value: nil)
    
    private func setupSelectedPlane() {
        selectedPlane
            .subscribe(onNext: { [weak self] (selectedPlane) in
                self?.foundPlanes.value.filter({ $0 != selectedPlane }).forEach({ $0.deselect() })
                selectedPlane?.select()
                if selectedPlane != nil {
                    DispatchQueue.main.async {
                        self?.status.accept(.resizePlane)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func createSelectablePlane(planeAnchor: ARPlaneAnchor) -> SelectablePlane {
        let contents: Any = UIColor.black.withAlphaComponent(0.3)
        let selectedContents: Any = UIColor.blue.withAlphaComponent(0.6)
        let selectablePlaneGeometry = SelectablePlaneGeometry(name: "SelectablePlaneGeometry", contents: contents, selectedContents: selectedContents)
        let selectablePlane = SelectablePlane(name: "SelectablePlane", selectablePlaneGeometry: selectablePlaneGeometry, anchor: planeAnchor)
        return selectablePlane
    }
    
    // MARK Action
    func addSelectablePlane(node: SCNNode, planeAnchor: ARPlaneAnchor) {
        let selectablePlane = createSelectablePlane(planeAnchor: planeAnchor)
        node.addChildNode(selectablePlane)
        addFound(plane: selectablePlane)
    }
    
    func didRemoveSelectablePlane(node: SCNNode, planeAnchor: ARPlaneAnchor) {
        node.selectableplanes.forEach({ removeFound(plane: $0) })
    }
    
    func didTapSelectablePlane(plane: SelectablePlane) {
        selectedPlane.accept(plane)
    }
    
    func didPinch(scale: CGFloat) {
        guard let plane = selectedPlane.value else { return }
        let action = SCNAction.scale(by: scale, duration: 0.1)
        plane.runAction(action)
    }
    
    func didRotate(rotation: CGFloat) {
        guard let plane = selectedPlane.value else { return }
        let action = SCNAction.rotate(by: rotation, around: SCNVector3(0, -1, 0), duration: 0.1)
        plane.runAction(action)
    }
    
    // MARK Update
    func updateSelectablePlane(node: SCNNode, planeAnchor: ARPlaneAnchor) {
        node.selectableplanes.forEach({
            $0.update(anchor: planeAnchor)
        })
    }
}
