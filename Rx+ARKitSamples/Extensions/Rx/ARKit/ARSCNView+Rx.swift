//
//  ARSCNView+Rx.swift
//  Rx+ARKitSamples
//
//  Created by 윤중현 on 2018. 10. 4..
//  Copyright © 2018년 tokijh. All rights reserved.
//

import ARKit
import RxSwift
import RxCocoa

extension Reactive where Base: ARSCNView {
    public typealias NodeAnchor = (node: SCNNode, anchor: ARAnchor)/// Reactive wrapper for `delegate`.
    ///
    /// For more information take a look at `DelegateProxyType` protocol documentation.
    public var arDelegate: DelegateProxy<ARSCNView, ARSCNViewDelegate> {
        return RxARSCNViewDelegateProxy.proxy(for: base)
    }
    
    // MARK ARSessionDelegate
    
    /// Reactive wrapper for delegate method `renderer(_:didAdd:for:)`
    public var didAdd: ControlEvent<NodeAnchor> {
        let source = arDelegate.methodInvoked(#selector(ARSCNViewDelegate.renderer(_:didAdd:for:)))
            .map { value -> NodeAnchor in
                let node = try castOrThrow(SCNNode.self, value[1])
                let anchor = try castOrThrow(ARAnchor.self, value[2])
                return (node, anchor)
        }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `renderer(_:willUpdate:for:)`
    public var willUpdate: ControlEvent<NodeAnchor> {
        let source = arDelegate.methodInvoked(#selector(ARSCNViewDelegate.renderer(_:willUpdate:for:)))
            .map { value -> NodeAnchor in
                let node = try castOrThrow(SCNNode.self, value[1])
                let anchor = try castOrThrow(ARAnchor.self, value[2])
                return (node, anchor)
        }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `renderer(_:didUpdate:for:)`
    public var didUpdate: ControlEvent<NodeAnchor> {
        let source = arDelegate.methodInvoked(#selector(ARSCNViewDelegate.renderer(_:didUpdate:for:)))
            .map { value -> NodeAnchor in
                let node = try castOrThrow(SCNNode.self, value[1])
                let anchor = try castOrThrow(ARAnchor.self, value[2])
                return (node, anchor)
        }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `renderer(_:didRemove:for:)`
    public var didRemove: ControlEvent<NodeAnchor> {
        let source = arDelegate.methodInvoked(#selector(ARSCNViewDelegate.renderer(_:didRemove:for:)))
            .map { value -> NodeAnchor in
                let node = try castOrThrow(SCNNode.self, value[1])
                let anchor = try castOrThrow(ARAnchor.self, value[2])
                return (node, anchor)
        }
        return ControlEvent(events: source)
    }
    
    // MARK ARSessionObserver
    
    /// Reactive wrapper for delegate method `session(_:didFailWithError:)`
    public var sessionDidFailWithError: ControlEvent<Error> {
        let source = arDelegate.methodInvoked(#selector(ARSessionObserver.session(_:didFailWithError:)))
            .map { value -> Error in
                let error = try castOrThrow(Error.self, value[1])
                return error
        }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `session(_:cameraDidChangeTrackingState:)`
    public var sessionCameraDidChangeTrackingState: ControlEvent<ARCamera> {
        let source = arDelegate.methodInvoked(#selector(ARSessionObserver.session(_:cameraDidChangeTrackingState:)))
            .map { value -> ARCamera in
                let camera = try castOrThrow(ARCamera.self, value[1])
                return camera
        }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `session(_:sessionWasInterrupted:)`
    public var sessionWasInterrupted: ControlEvent<Void> {
        let source = arDelegate.methodInvoked(#selector(ARSessionObserver.sessionWasInterrupted(_:)))
            .map({ _ in })
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `session(_:sessionInterruptionEnded:)`
    public var sessionInterruptionEnded: ControlEvent<Void> {
        let source = arDelegate.methodInvoked(#selector(ARSessionObserver.sessionInterruptionEnded(_:)))
            .map({ _ in })
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `session(_:sessionInterruptionEnded:)`
    public var sessionDidOutputAudioSampleBuffer: ControlEvent<CMSampleBuffer> {
        let source = arDelegate.methodInvoked(#selector(ARSessionObserver.session(_:didOutputAudioSampleBuffer:)))
            .map { value -> CMSampleBuffer in
                let sampleBuffer = try castOrThrow(CMSampleBuffer.self, value[1])
                return sampleBuffer
        }
        return ControlEvent(events: source)
    }
    
    // MARK SCNSceneRendererDelegate
    
    /// Reactive wrapper for delegate method `renderer(_:updateAtTime:)`
    public var updateAtTime: ControlEvent<TimeInterval> {
        let source = arDelegate.methodInvoked(#selector(SCNSceneRendererDelegate.renderer(_:updateAtTime:)))
            .map { value -> TimeInterval in
                let time = try castOrThrow(TimeInterval.self, value[1])
                return time
        }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `renderer(_:updateAtTime:)`
    public var didApplyAnimationsAtTime: ControlEvent<TimeInterval> {
        let source = arDelegate.methodInvoked(#selector(SCNSceneRendererDelegate.renderer(_:didApplyAnimationsAtTime:)))
            .map { value -> TimeInterval in
                let time = try castOrThrow(TimeInterval.self, value[1])
                return time
        }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `renderer(_:updateAtTime:)`
    public var didSimulatePhysicsAtTime: ControlEvent<TimeInterval> {
        let source = arDelegate.methodInvoked(#selector(SCNSceneRendererDelegate.renderer(_:didSimulatePhysicsAtTime:)))
            .map { value -> TimeInterval in
                let time = try castOrThrow(TimeInterval.self, value[1])
                return time
        }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `renderer(_:updateAtTime:)`
    @available(iOS 11.0, *)
    public var didApplyConstraintsAtTime: ControlEvent<TimeInterval> {
        let source = arDelegate.methodInvoked(#selector(SCNSceneRendererDelegate.renderer(_:didApplyConstraintsAtTime:)))
            .map { value -> TimeInterval in
                let time = try castOrThrow(TimeInterval.self, value[1])
                return time
        }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `renderer(_:willRenderScene:atTime:)`
    public var willRenderSceneAtTime: ControlEvent<SceneTime> {
        let source = arDelegate.methodInvoked(#selector(SCNSceneRendererDelegate.renderer(_:willRenderScene:atTime:)))
            .map { value -> SceneTime in
                let scene = try castOrThrow(SCNScene.self, value[1])
                let time = try castOrThrow(TimeInterval.self, value[2])
                return (scene, time)
        }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `renderer(_:willRenderScene:atTime:)`
    public var didRenderSceneAtTime: ControlEvent<SceneTime> {
        let source = arDelegate.methodInvoked(#selector(SCNSceneRendererDelegate.renderer(_:didRenderScene:atTime:)))
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
    public func setDelegate(_ delegate: ARSCNViewDelegate) -> Disposable {
        return RxARSCNViewDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: self.base)
    }
}
