//
//  UINavigationController+Rx.swift
//  Rx+ARKitSamples
//
//  Created by 윤중현 on 06/10/2018.
//  Copyright © 2018 tokijh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UINavigationController {
    var setNavigationBarHidden: Binder<(hidden: Bool, animated: Bool)> {
        return Binder<(hidden: Bool, animated: Bool)>(base) { nav, value in
            nav.setNavigationBarHidden(value.hidden, animated: value.animated)
        }
    }
}
