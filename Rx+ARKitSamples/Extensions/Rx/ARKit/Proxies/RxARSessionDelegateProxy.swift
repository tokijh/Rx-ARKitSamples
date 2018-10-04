//
//  RxARSessionDelegateProxy.swift
//  Rx+ARKitSamples
//
//  Created by 윤중현 on 2018. 10. 4..
//  Copyright © 2018년 tokijh. All rights reserved.
//

import ARKit
import RxSwift
import RxCocoa

extension ARSession: HasDelegate {
    public typealias Delegate = ARSessionDelegate
}

open class RxARSessionDelegateProxy:
    DelegateProxy<ARSession, ARSessionDelegate>,
    DelegateProxyType,
    ARSessionDelegate {
    
    /// Typed parent object.
    public weak private(set) var session: ARSession?
    
    /// - parameter view: Parent object for delegate proxy.
    public init(session: ARSession) {
        self.session = session
        super.init(parentObject: session, delegateProxy: RxARSessionDelegateProxy.self)
    }
    
    // Register known implementations
    public class func registerKnownImplementations() {
        self.register { RxARSessionDelegateProxy(session: $0) }
    }
}
