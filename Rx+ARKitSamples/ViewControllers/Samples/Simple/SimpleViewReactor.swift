//
//  SimpleViewReactor.swift
//  Rx+ARKitSamples
//
//  Created by 윤중현 on 2018. 10. 4..
//  Copyright © 2018년 tokijh. All rights reserved.
//

import ReactorKit
import RxSwift
import ARKit

class SimpleViewReactor: Reactor {
    // MARK Reactor
    enum Action {
        case viewWillAppear
        case viewDidAppear
        case viewWillDisappear
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
            let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
            return Observable.just(.run(configuration, options))
        case .viewWillDisappear:
            let setNavigationBarHidden = Observable.just(Mutation.setNavigationBarHidden(false, animated: true))
            let pause = Observable.just(Mutation.pause(shouldPause: true))
            return Observable.concat(setNavigationBarHidden, pause)
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
}
