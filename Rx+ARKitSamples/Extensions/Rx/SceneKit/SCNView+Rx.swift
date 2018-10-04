//
//  SCNView+Rx.swift
//  Rx+ARKitSamples
//
//  Created by 윤중현 on 2018. 10. 4..
//  Copyright © 2018년 tokijh. All rights reserved.
//

import SceneKit
import RxSwift
import RxCocoa

extension Reactive where Base: SCNView {
    public typealias SceneTime = (scene: SCNScene, time: TimeInterval)
    /// Reactive wrapper for `delegate`.
    ///
    /// For more information take a look at `DelegateProxyType` protocol documentation.
    public var redererDelegate: DelegateProxy<SCNView, SCNSceneRendererDelegate> {
        return RxSCNSceneRendererDelegateProxy.proxy(for: base)
    }
    
    /// Reactive wrapper for delegate method `renderer(_:updateAtTime:)`
    public var updateAtTime: ControlEvent<TimeInterval> {
        let source = redererDelegate.methodInvoked(#selector(SCNSceneRendererDelegate.renderer(_:updateAtTime:)))
            .map { value -> TimeInterval in
                let time = try castOrThrow(TimeInterval.self, value[1])
                return time
        }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `renderer(_:updateAtTime:)`
    public var didApplyAnimationsAtTime: ControlEvent<TimeInterval> {
        let source = redererDelegate.methodInvoked(#selector(SCNSceneRendererDelegate.renderer(_:didApplyAnimationsAtTime:)))
            .map { value -> TimeInterval in
                let time = try castOrThrow(TimeInterval.self, value[1])
                return time
        }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `renderer(_:updateAtTime:)`
    public var didSimulatePhysicsAtTime: ControlEvent<TimeInterval> {
        let source = redererDelegate.methodInvoked(#selector(SCNSceneRendererDelegate.renderer(_:didSimulatePhysicsAtTime:)))
            .map { value -> TimeInterval in
                let time = try castOrThrow(TimeInterval.self, value[1])
                return time
        }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `renderer(_:updateAtTime:)`
    @available(iOS 11.0, *)
    public var didApplyConstraintsAtTime: ControlEvent<TimeInterval> {
        let source = redererDelegate.methodInvoked(#selector(SCNSceneRendererDelegate.renderer(_:didApplyConstraintsAtTime:)))
            .map { value -> TimeInterval in
                let time = try castOrThrow(TimeInterval.self, value[1])
                return time
        }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `renderer(_:willRenderScene:atTime:)`
    public var willRenderSceneAtTime: ControlEvent<SceneTime> {
        let source = redererDelegate.methodInvoked(#selector(SCNSceneRendererDelegate.renderer(_:willRenderScene:atTime:)))
            .map { value -> SceneTime in
                let scene = try castOrThrow(SCNScene.self, value[1])
                let time = try castOrThrow(TimeInterval.self, value[2])
                return (scene, time)
        }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `renderer(_:willRenderScene:atTime:)`
    public var didRenderSceneAtTime: ControlEvent<SceneTime> {
        let source = redererDelegate.methodInvoked(#selector(SCNSceneRendererDelegate.renderer(_:didRenderScene:atTime:)))
            .map { value -> SceneTime in
                let scene = try castOrThrow(SCNScene.self, value[1])
                let time = try castOrThrow(TimeInterval.self, value[2])
                return (scene, time)
        }
        return ControlEvent(events: source)
    }
    
    /// Installs delegate as forwarding delegate on `delegate`.
    /// Delegate won't be retained.
    ///
    /// It enables using normal delegate mechanism with reactive delegate mechanism.
    ///
    /// - parameter delegate: Delegate object.
    /// - returns: Disposable object that can be used to unbind the delegate.
    public func setDelegate(_ delegate: SCNSceneRendererDelegate) -> Disposable {
        return RxSCNSceneRendererDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: self.base)
    }
}
