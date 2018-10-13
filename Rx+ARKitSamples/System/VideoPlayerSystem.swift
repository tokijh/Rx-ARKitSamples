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

let sampleVideoURL = URL(string: "https://r13---sn-gvnuxaxjvh-bvwz.googlevideo.com/videoplayback?sparams=dur%2Cei%2Cid%2Cip%2Cipbits%2Citag%2Clmt%2Cmime%2Cmm%2Cmn%2Cms%2Cmv%2Cnh%2Cpl%2Cratebypass%2Crequiressl%2Csource%2Cexpire&itag=22&lmt=1521024521911836&c=WEB&requiressl=yes&expire=1539441889&key=yt6&dur=78.437&mv=m&pl=24&mt=1539420191&nh=%2CIgpwcjAyLnN2bzAzKgkxMjcuMC4wLjE&ms=au%2Conr&id=o-AEprFQDWFYZCtQcv0LaMfzdvjzh8gOM738VRhev-Fpi_&ei=gbDBW6udCIapyQW2rL6oBg&signature=7E9A1EF48CEB4EAA97AA738505C3F0643E164AB9.5C1B205683DB0006EB81C2DFD976F2BCB4D1BE6C&fvip=13&ip=193.233.157.2&mime=video%2Fmp4&ipbits=0&ratebypass=yes&mn=sn-gvnuxaxjvh-bvwz%2Csn-axq7sn7l&source=youtube&mm=31%2C26&video_id=bigzMV9rX1U&title=%5B%EC%9C%A0%EC%95%84%EB%8F%99%EC%9E%91%EA%B5%90%EC%9C%A1_%EC%97%B0%EC%96%B4%5D+1.+%EB%8F%84%EC%9E%85+%EB%B0%9D%EC%9D%80%EB%B0%94%EB%8B%A4%EB%B0%B0%EA%B2%BDArabesque+No+1")!

class VideoPlayerSystem {
    
    init() {
        setup()
    }
    
    private func setup() {
        setupFoundPlanes()
        setupSelectedPlane()
        setupVideoNode()
    }
    
    // MARK DisposeBag
    var disposeBag = DisposeBag()
    
    // MARK Status
    enum Status {
        case selectPlane
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
                        self?.status.accept(.showVideo)
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
    
    // MARK Video
    let videoNode = BehaviorRelay<VideoNode?>(value: nil)
    
    private func setupVideoNode() {
        status
            .debug()
            .filter({ $0 == .showVideo })
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] _ in
                self?.addVideoNodeInSelectedPlane()
            })
            .disposed(by: disposeBag)
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
        switch status.value {
        case .selectPlane:
            selectedPlane.accept(plane)
        case .showVideo: break
        }
    }
    
    func didPinch(scale: CGFloat) {
        guard status.value == .showVideo,
            let plane = selectedPlane.value
            else { return }
        let action = SCNAction.scale(by: scale, duration: 0.1)
        plane.runAction(action)
    }
    
    func didRotate(rotation: CGFloat) {
        guard status.value == .showVideo,
            let plane = selectedPlane.value
            else { return }
        let action = SCNAction.rotate(by: rotation, around: SCNVector3(0, -1, 0), duration: 0.1)
        plane.runAction(action)
    }
    
    func addVideoNodeInSelectedPlane() {
        guard self.videoNode.value == nil,
            let plane = selectedPlane.value
            else { return }
        let videoNode = VideoNode(name: "VideoPlayer", url: sampleVideoURL, planeGeometry: SCNPlane(width: 1.0, height: 0.75))
        plane.addChildNode(videoNode)
        self.videoNode.accept(videoNode)
        hidePlaneContents(plane)
    }
    
    func hidePlaneContents(_ plane: Plane) {
        if let geometry = plane.geometry as? SelectablePlaneGeometry {
            geometry.isShowSelector = false
        }
        plane.geometry?.firstMaterial?.diffuse.contents = UIColor.clear
    }
    
    // MARK Update
    func updateSelectablePlane(node: SCNNode, planeAnchor: ARPlaneAnchor) {
        node.selectableplanes.forEach({
            $0.update(anchor: planeAnchor)
        })
    }
}
