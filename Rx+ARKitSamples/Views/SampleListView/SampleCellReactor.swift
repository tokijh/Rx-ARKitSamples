//
//  SampleCellReactor.swift
//  Rx+ARKitSamples
//
//  Created by 윤중현 on 2018. 10. 4..
//  Copyright © 2018년 tokijh. All rights reserved.
//

import ReactorKit

class SampleCellReactor: Reactor {
    // MARK Reactor
    typealias Action = NoAction
    
    struct State {
        var sample: Sample
        var title: String
        var description: String
    }
    
    let initialState: State
    
    init(sample: Sample) {
        initialState = State(sample: sample, title: sample.title, description: sample.description)
    }
}
