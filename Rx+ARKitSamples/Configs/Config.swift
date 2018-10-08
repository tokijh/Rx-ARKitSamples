//
//  Config.swift
//  Rx+ARKitSamples
//
//  Created by 윤중현 on 2018. 10. 4..
//  Copyright © 2018년 tokijh. All rights reserved.
//

class Config {
    enum Sample: CaseIterable {
        case simple
        case planeDetection
    }
}

extension Config.Sample {
    static var allSamples: [Sample] {
        return Config.Sample.allCases.map({
            switch $0 {
            case .simple: return Sample(title: "Simple",
                                        description: "Simple ARSCNView",
                                        controller: .simple)
            case .planeDetection: return Sample(title: "Plane Detection",
                                                description: "A sample to show how simply ARKit can detect planes.",
                                                controller: .planeDetection)
            }
        })
    }
}
