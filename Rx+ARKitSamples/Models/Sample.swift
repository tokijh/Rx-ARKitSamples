//
//  Sample.swift
//  Rx+ARKitSamples
//
//  Created by 윤중현 on 2018. 10. 4..
//  Copyright © 2018년 tokijh. All rights reserved.
//

import UIKit

public struct Sample {
    let title: String
    let description: String
    let controller: Controller
    
    enum Controller {
        case simple
        case planeDetection
        case videoPlayer
    }
}

extension Sample.Controller {
    var vc: UIViewController {
        switch self {
        case .simple: return SimpleViewController()
        case .planeDetection: return PlaneDetectionViewController()
        case .videoPlayer: return VideoPlayerViewController()
        }
    }
}
