//
//  ARSession+Rx.swift
//  Rx+ARKitSamples
//
//  Created by 윤중현 on 2018. 10. 4..
//  Copyright © 2018년 tokijh. All rights reserved.
//

import ARKit
import RxSwift
import RxCocoa

extension Reactive where Base: ARSession {
    
    /// Reactive wrapper for `delegate`.
    ///
    /// For more information take a look at `DelegateProxyType` protocol documentation.
    public var delegate: DelegateProxy<ARSession, ARSessionDelegate> {
        return RxARSessionDelegateProxy.proxy(for: base)
    }
    
    // MARK ARSessionDelegate
    
    // Reactive wrapper for delegate method `session(_:didUpdate:)`
    public var didUpdateFrame: ControlEvent<ARFrame> {
        let source: Observable<ARFrame> = delegate
            .methodInvoked(#selector(ARSessionDelegate.session(_:didUpdate:) as ((ARSessionDelegate) -> (ARSession, ARFrame) -> Void)?))
            .map { value -> ARFrame in
                let camera = try castOrThrow(ARFrame.self, value[1])
                return camera
        }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `session(_:didAdd:)`
    public var didAddAnchors: ControlEvent<[ARAnchor]> {
        let source = delegate.methodInvoked(#selector(ARSessionDelegate.session(_:didAdd:)))
            .map { value -> [ARAnchor] in
                let anchors = try castOrThrow([ARAnchor].self, value[1])
                return anchors
        }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `session(_:didAdd:)`
    public var didUpdateAnchors: ControlEvent<[ARAnchor]> {
        let source = delegate
            .methodInvoked(#selector(ARSessionDelegate.session(_:didUpdate:) as ((ARSessionDelegate) -> (ARSession, [ARAnchor]) -> Void)?))
            .map { value -> [ARAnchor] in
                let anchors = try castOrThrow([ARAnchor].self, value[1])
                return anchors
        }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `session(_:didRemove:)`
    public var didRemoveAnchors: ControlEvent<[ARAnchor]> {
        let source = delegate.methodInvoked(#selector(ARSessionDelegate.session(_:didRemove:)))
            .map { value -> [ARAnchor] in
                let anchors = try castOrThrow([ARAnchor].self, value[1])
                return anchors
        }
        return ControlEvent(events: source)
    }
    
    
    // MARK ARSessionObserver
    
    /// Reactive wrapper for delegate method `session(_:didFailWithError:)`
    public var sessionDidFailWithError: ControlEvent<Error> {
        let source = delegate.methodInvoked(#selector(ARSessionObserver.session(_:didFailWithError:)))
            .map { value -> Error in
                let error = try castOrThrow(Error.self, value[1])
                return error
        }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `session(_:cameraDidChangeTrackingState:)`
    public var sessionCameraDidChangeTrackingState: ControlEvent<ARCamera> {
        let source = delegate.methodInvoked(#selector(ARSessionObserver.session(_:cameraDidChangeTrackingState:)))
            .map { value -> ARCamera in
                let camera = try castOrThrow(ARCamera.self, value[1])
                return camera
        }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `session(_:sessionWasInterrupted:)`
    public var sessionWasInterrupted: ControlEvent<Void> {
        let source = delegate.methodInvoked(#selector(ARSessionObserver.sessionWasInterrupted(_:)))
            .map({ _ in })
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `session(_:sessionInterruptionEnded:)`
    public var sessionInterruptionEnded: ControlEvent<Void> {
        let source = delegate.methodInvoked(#selector(ARSessionObserver.sessionInterruptionEnded(_:)))
            .map({ _ in })
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `session(_:sessionInterruptionEnded:)`
    public var sessionDidOutputAudioSampleBuffer: ControlEvent<CMSampleBuffer> {
        let source = delegate.methodInvoked(#selector(ARSessionObserver.session(_:didOutputAudioSampleBuffer:)))
            .map { value -> CMSampleBuffer in
                let sampleBuffer = try castOrThrow(CMSampleBuffer.self, value[1])
                return sampleBuffer
        }
        return ControlEvent(events: source)
    }
    
    public var run: Binder<(ARConfiguration, ARSession.RunOptions)> {
        return Binder<(ARConfiguration, ARSession.RunOptions)>(base) { (base, value) in
            let (configuration, options) = value
            base.run(configuration, options: options)
        }
    }
    
    public var pause: Binder<Void> {
        return Binder<Void>(base) { (base, value) in
            base.pause()
        }
    }
    
    /// Installs delegate as forwarding delegate on `delegate`.
    /// Delegate won't be retained.
    ///
    /// It enables using normal delegate mechanism with reactive delegate mechanism.
    ///
    /// - parameter delegate: Delegate object.
    /// - returns: Disposable object that can be used to unbind the delegate.
    public func setDelegate(_ delegate: ARSessionDelegate) -> Disposable {
        return RxARSessionDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: self.base)
    }
}
