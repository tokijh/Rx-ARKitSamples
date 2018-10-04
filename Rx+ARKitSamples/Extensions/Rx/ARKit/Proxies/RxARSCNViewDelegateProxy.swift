//
//  RxARSCNViewDelegateProxy.swift
//  Rx+ARKitSamples
//
//  Created by 윤중현 on 2018. 10. 4..
//  Copyright © 2018년 tokijh. All rights reserved.
//

import ARKit
import RxSwift
import RxCocoa

open class RxARSCNViewDelegateProxy:
    DelegateProxy<ARSCNView, ARSCNViewDelegate>,
    DelegateProxyType,
    ARSCNViewDelegate {
    
    public static func currentDelegate(for object: ARSCNView) -> ARSCNViewDelegate? {
        return object.delegate
    }
    
    public static func setCurrentDelegate(_ delegate: ARSCNViewDelegate?, to object: ARSCNView) {
        object.delegate = delegate
    }
    
    /// Typed parent object.
    public weak private(set) var arSCNView: ARSCNView?
    
    /// - parameter view: Parent object for delegate proxy.
    public init(arSCNView: ARSCNView) {
        self.arSCNView = arSCNView
        super.init(parentObject: arSCNView, delegateProxy: RxARSCNViewDelegateProxy.self)
    }
    
    // Register known implementations
    public class func registerKnownImplementations() {
        self.register { RxARSCNViewDelegateProxy(arSCNView: $0) }
    }
}
