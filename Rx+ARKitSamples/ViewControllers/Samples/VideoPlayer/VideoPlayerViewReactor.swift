//
//  VideoPlayerViewReactor.swift
//  Rx+ARKitSamples
//
//  Created by 윤중현 on 07/10/2018.
//  Copyright © 2018 tokijh. All rights reserved.
//

import ReactorKit
import RxSwift
import ARKit

class VideoPlayerViewReactor: Reactor {
    
    init() {
        setupSystem()
    }
    
    // MARK DisposeBag
    var disposeBag = DisposeBag()
    
    // MARK Reactor
    enum Action {
        case viewWillAppear
        case viewDidAppear
        case viewWillDisappear
        case didAdd(node: SCNNode, planeAnchor: ARPlaneAnchor)
        case didUpdate(node: SCNNode, planeAnchor: ARPlaneAnchor)
        case didRemove(node: SCNNode, planeAnchor: ARPlaneAnchor)
        case didTapSelectablePlane(SelectablePlane)
        
        case run(ARConfiguration, ARSession.RunOptions)
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
            system.addSelectablePlane(node: node, planeAnchor: planeAnchor)
        case let .didUpdate(node, planeAnchor):
            system.updateSelectablePlane(node: node, planeAnchor: planeAnchor)
        case let .didRemove(node, planeAnchor):
            system.didRemoveSelectablePlane(node: node, planeAnchor: planeAnchor)
        case let .didTapSelectablePlane(plane):
            system.didTapSelectablePlane(plane: plane)
            
        case let .run(configuration, options):
            return .just(Mutation.run(configuration, options))
        }
        return .empty()
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
    
    // MARK System
    let system = VideoPlayerSystem()
    
    private func setupSystem() {
        system.status
            .filter({ $0 == VideoPlayerSystem.Status.resizePlane })
            .map({ _ -> Action in
                let configuration = ARWorldTrackingConfiguration()
                let options: ARSession.RunOptions = []
                return Action.run(configuration, options)
            })
            .bind(to: action)
            .disposed(by: disposeBag)
    }
}
