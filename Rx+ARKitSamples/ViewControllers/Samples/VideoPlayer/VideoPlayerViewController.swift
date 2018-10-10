//
//  VideoPlayerViewController.swift
//  Rx+ARKitSamples
//
//  Created by 윤중현 on 07/10/2018.
//  Copyright © 2018 tokijh. All rights reserved.
//

import UIKit
import ARKit
import ReactorKit
import RxSwift

class VideoPlayerViewController: UIViewController, View {
    // MARK typealias
    fileprivate typealias State = VideoPlayerViewReactor.State
    fileprivate typealias Action = VideoPlayerViewReactor.Action
    
    // MARK DisposeBag
    var disposeBag = DisposeBag()
    
    // MARK Life cycle
    init(reactor: VideoPlayerViewReactor = VideoPlayerViewReactor()) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupView()
    }
    
    // MARK Reactor Binder
    func bind(reactor: VideoPlayerViewReactor) {
        bind(state: reactor.state)
        bind(action: reactor.action)
    }
    
    private func bind(state: Observable<State>) {
        bindView(state: state)
        bindSceneView(state: state)
    }
    
    private func bind(action: ActionSubject<Action>) {
        bindView(action: action)
        bindSceneView(action: action)
    }
    
    // MARK View
    private func setupView() {
        view.backgroundColor = UIColor.white
        layoutView()
    }
    
    private func layoutView() {
        view.addSubview(sceneView)
        sceneView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func bindView(state: Observable<State>) {
        state.map({ $0.isNavigationBarHidden })
            .subscribe(onNext: { [weak self] (hidden, animated) in
                self?.navigationController?.setNavigationBarHidden(hidden, animated: animated)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindView(action: ActionSubject<Action>) {
        rx.viewWillAppear.map({ _ in Action.viewWillAppear }).bind(to: action).disposed(by: disposeBag)
        rx.viewDidAppear.map({ _ in Action.viewDidAppear }).bind(to: action).disposed(by: disposeBag)
        rx.viewWillDisappear.map({ _ in Action.viewWillDisappear }).bind(to: action).disposed(by: disposeBag)
    }
    
    // MARK SceneView
    public private(set) lazy var sceneView = ARSCNView().then {
        #if DEBUG
        $0.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        $0.showsStatistics = true
        #endif
    }
    
    private func bindSceneView(state: Observable<State>) {
        let isPaused = state.map({ $0.isPaused })
        isPaused
            .filter({ !$0 }) // should be not pause
            .withLatestFrom(state.map({ $0.configuration }))
            .filterNil() // Configuration should be not nil
            .withLatestFrom(state.map({ $0.sessionRunOptions })) { ($0, $1) }
            .bind(to: sceneView.session.rx.run)
            .disposed(by: disposeBag)
        isPaused
            .filter({ $0 }) // should be pause
            .asVoid()
            .bind(to: sceneView.session.rx.pause)
            .disposed(by: disposeBag)
    }
    
    private func bindSceneView(action: ActionSubject<Action>) {
        sceneView.rx.didAdd
            .map({ (node, anchor) -> (node: SCNNode, planeAnchor: ARPlaneAnchor)? in
                guard let planeAnchor = anchor as? ARPlaneAnchor else { return nil }
                return (node, planeAnchor)
            })
            .filterNil()
            .map({ Action.didAdd(node: $0.node, planeAnchor: $0.planeAnchor) })
            .bind(to: action)
            .disposed(by: disposeBag)
        sceneView.rx.didUpdate
            .map({ (node, anchor) -> (node: SCNNode, planeAnchor: ARPlaneAnchor)? in
                guard let planeAnchor = anchor as? ARPlaneAnchor else { return nil }
                return (node, planeAnchor)
            })
            .filterNil()
            .map({ Action.didUpdate(node: $0.node, planeAnchor: $0.planeAnchor) })
            .bind(to: action)
            .disposed(by: disposeBag)
        sceneView.rx.didRemove
            .map({ (node, anchor) -> (node: SCNNode, planeAnchor: ARPlaneAnchor)? in
                guard let planeAnchor = anchor as? ARPlaneAnchor else { return nil }
                return (node, planeAnchor)
            })
            .filterNil()
            .map({ Action.didRemove(node: $0.node, planeAnchor: $0.planeAnchor) })
            .bind(to: action)
            .disposed(by: disposeBag)
        bindSceneViewGesture(action: action)
    }
    
    private func bindSceneViewGesture(action: ActionSubject<Action>) {
        let _sceneView = Observable.just(sceneView)
        let tapGesture = UITapGestureRecognizer()
        sceneView.addGestureRecognizer(tapGesture)
        tapGesture.rx.event
            .withLatestFrom(_sceneView) { (gesture, sceneView) -> [ARHitTestResult] in
                let location = gesture.location(in: sceneView)
                return sceneView.hitTest(location, types: .existingPlaneUsingExtent)
            }
            .map({ $0.first?.anchor })
            .filterNil()
            .withLatestFrom(_sceneView) { (anchor, sceneView) -> SelectablePlane? in
                let node = sceneView.node(for: anchor)
                let selectableplane = node?.selectableplanes.first
                return selectableplane
            }
            .filterNil()
            .map({ Action.didTapSelectablePlane($0) })
            .bind(to: action)
            .disposed(by: disposeBag)
    }
}
