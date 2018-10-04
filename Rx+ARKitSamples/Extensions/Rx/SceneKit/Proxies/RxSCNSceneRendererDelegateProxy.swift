//
//  RxSCNSceneRendererDelegateProxy.swift
//  Rx+ARKitSamples
//
//  Created by 윤중현 on 2018. 10. 4..
//  Copyright © 2018년 tokijh. All rights reserved.
//

import SceneKit
import RxSwift
import RxCocoa

open class RxSCNSceneRendererDelegateProxy:
    DelegateProxy<SCNView, SCNSceneRendererDelegate>,
    DelegateProxyType,
    SCNSceneRendererDelegate {
    
    public static func currentDelegate(for object: SCNView) -> SCNSceneRendererDelegate? {
        return object.delegate
    }
    
    public static func setCurrentDelegate(_ delegate: SCNSceneRendererDelegate?, to object: SCNView) {
        object.delegate = delegate
    }
    
    /// Typed parent object.
    public weak private(set) var scnView: SCNView?
    
    /// - parameter view: Parent object for delegate proxy.
    public init(scnView: SCNView) {
        self.scnView = scnView
        super.init(parentObject: scnView, delegateProxy: RxSCNSceneRendererDelegateProxy.self)
    }
    
    // Register known implementations
    public class func registerKnownImplementations() {
        self.register { RxSCNSceneRendererDelegateProxy(scnView: $0) }
    }
}
