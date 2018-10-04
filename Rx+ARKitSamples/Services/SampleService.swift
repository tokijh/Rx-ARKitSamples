//
//  SampleService.swift
//  Rx+ARKitSamples
//
//  Created by 윤중현 on 2018. 10. 4..
//  Copyright © 2018년 tokijh. All rights reserved.
//

import RxSwift

protocol SampleServiceType: ServiceType {
    func samples() -> Single<[Sample]>
}

class SampleService: SampleServiceType {
    func samples() -> Single<[Sample]> {
        return Single.just(Config.Sample.allSamples)
    }
}
