//
//  SampleListViewReactor.swift
//  Rx+ARKitSamples
//
//  Created by 윤중현 on 2018. 10. 4..
//  Copyright © 2018년 tokijh. All rights reserved.
//

import ReactorKit
import RxSwift

class SampleListViewReactor: Reactor {
    // MARK Reactor
    enum Action {
        case refresh
        case select(SampleCellReactor)
    }
    
    enum Mutation {
        case setRefreshing(Bool)
        case setLoading(Bool)
        case setSamples([Sample])
        case move(to: UIViewController)
    }
    
    struct State {
        var isRefreshing: Bool = false
        var isLoading: Bool = false
        var sections: [SampleCellReactor] = []
        var shouldMoveToVC: UIViewController?
    }
    
    let initialState = State()
    
    // MARK Service
    let sampleService: SampleServiceType
    
    init(sampleService: SampleServiceType = SampleService()) {
        self.sampleService = sampleService
    }
    
    func mutate(action: SampleListViewReactor.Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            guard !currentState.isRefreshing,
                !currentState.isLoading
                else { return .empty() }
            let startRefreshing = Observable<Mutation>.just(.setRefreshing(true))
            let endRefreshing = Observable<Mutation>.just(.setRefreshing(false))
            let setSamples = sampleService.samples().asObservable()
                .map({ samples -> Mutation in
                    return .setSamples(samples)
                })
            return .concat([startRefreshing, setSamples, endRefreshing])
        case let .select(sampleReactor):
            let sample = sampleReactor.currentState.sample
            let vc = sample.controller
            return Observable.just(Mutation.move(to: vc))
        }
    }
    
    func reduce(state: SampleListViewReactor.State, mutation: SampleListViewReactor.Mutation) -> SampleListViewReactor.State {
        var state = state
        switch mutation {
        case let .setRefreshing(isRefreshing):
            let isEmpty = state.sections.isEmpty == true
            state.isRefreshing = isRefreshing && !isEmpty
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        case let .setSamples(samples):
            state.sections = samples.map({ SampleCellReactor(sample: $0) })
        case let .move(to: vc):
            state.shouldMoveToVC = vc
        }
        return state
    }
}
