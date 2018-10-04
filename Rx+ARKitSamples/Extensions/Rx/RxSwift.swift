//
//  RxSwift.swift
//  Rx+ARKitSamples
//
//  Created by 윤중현 on 2018. 10. 4..
//  Copyright © 2018년 tokijh. All rights reserved.
//

import RxSwift

extension ObservableType {
    func asVoid() -> Observable<Void> {
        return self.map({ _ in Void() })
    }
}
