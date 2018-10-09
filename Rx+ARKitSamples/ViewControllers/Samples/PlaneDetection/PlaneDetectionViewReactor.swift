//
//  PlaneDetectionViewReactor.swift
//  Rx+ARKitSamples
//
//  Created by 윤중현 on 07/10/2018.
//  Copyright © 2018 tokijh. All rights reserved.
//

import ReactorKit
import RxSwift
import ARKit

class PlaneDetectionViewReactor: Reactor {
    // MARK Reactor
    enum Action {
        case viewWillAppear
        case viewDidAppear
        case viewWillDisappear
        case didAdd(node: SCNNode, planeAnchor: ARPlaneAnchor)
        case didUpdate(node: SCNNode, planeAnchor: ARPlaneAnchor)
    }
    
    enum Mutation {
        case run(ARConfiguration, ARSession.RunOptions)
        case pause(shouldPause: Bool)
        case setNavigationBarHidden(Bool, animated: Bool)
    }
    
    struct State {
        var isPaused: Bool = true
        var configuration: ARConfiguration? = nil
        var sessionRunOptions: ARSession.RunOptions = []
        var isNavigationBarHidden: (Bool, animated: Bool) = (false, false)
    }
    
    let initialState = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewWillAppear:
            return Observable.just(.setNavigationBarHidden(true, animated: true))
        case .viewDidAppear:
            let configuration = ARWorldTrackingConfiguration()
            if #available(iOS 11.3, *) {
                configuration.planeDetection = [.horizontal, .vertical]
            } else {
                configuration.planeDetection = [.horizontal]
            }
            let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
            return Observable.just(.run(configuration, options))
        case .viewWillDisappear:
            let setNavigationBarHidden = Observable.just(Mutation.setNavigationBarHidden(false, animated: true))
            let pause = Observable.just(Mutation.pause(shouldPause: true))
            return Observable.concat(setNavigationBarHidden, pause)
        case let .didAdd(node, planeAnchor):
            addPlane(node: node, planeAnchor: planeAnchor)
            if #available(iOS 11.3, *) {
                addMeshPlane(node: node, planeAnchor: planeAnchor)
            }
            return .empty()
        case let .didUpdate(node, planeAnchor):
            updatePlane(node: node, planeAnchor: planeAnchor)
            if #available(iOS 11.3, *) {
                updateMeshPlane(node: node, planeAnchor: planeAnchor)
            }
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .pause(shouldPause):
            if shouldPause {
                state.isPaused = true
                state.configuration = nil
                state.sessionRunOptions = []
            }
        case let .run(configuration, runOptions):
            state.configuration = configuration
            state.sessionRunOptions = runOptions
            state.isPaused = false
        case let .setNavigationBarHidden(isHidden):
            state.isNavigationBarHidden = isHidden
        }
        return state
    }
    
    // MARK Device
    private let device: MTLDevice = MTLCreateSystemDefaultDevice()!
    
    // MARK Nodes
    private func addPlane(node: SCNNode, planeAnchor: ARPlaneAnchor) {
        let contents: Any
        switch planeAnchor.alignment {
        case .horizontal:
            contents = UIColor.blue.withAlphaComponent(0.3)
        case .vertical:
            contents = UIColor.red.withAlphaComponent(0.3)
        }
        let planeGeometry = PlaneGeometry(name: "PlaneGeometry", contents: contents)
        let plane = Plane(name: "Plane", planeGeometry: planeGeometry, anchor: planeAnchor)
        node.addChildNode(plane)
    }
    
    private func updatePlane(node: SCNNode, planeAnchor: ARPlaneAnchor) {
        node.planes.forEach({
            $0.update(anchor: planeAnchor)
        })
    }
    
    @available(iOS 11.3, *)
    private func addMeshPlane(node: SCNNode, planeAnchor: ARPlaneAnchor) {
        guard let arscnPlaneGeometry = ARSCNPlaneGeometry(name: "ARSCNPlaneGeometry", device: device, contents: UIColor.green.withAlphaComponent(0.3)) else { return }
        let meshPlane = MeshPlane(name: "MeshPlane", planeGeometry: arscnPlaneGeometry, anchor: planeAnchor)
        node.addChildNode(meshPlane)
    }
    
    @available(iOS 11.3, *)
    private func updateMeshPlane(node: SCNNode, planeAnchor: ARPlaneAnchor) {
        node.meshPlanes.forEach({
            $0.update(anchor: planeAnchor)
        })
    }
}
