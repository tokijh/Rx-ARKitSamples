//
//  SimpleViewController.swift
//  Rx+ARKitSamples
//
//  Created by 윤중현 on 2018. 10. 4..
//  Copyright © 2018년 tokijh. All rights reserved.
//

import UIKit
import ARKit
import ReactorKit
import RxSwift

class SimpleViewController: UIViewController, View {
    // MARK typealias
    fileprivate typealias State = SimpleViewReactor.State
    fileprivate typealias Action = SimpleViewReactor.Action
    
    // MARK DisposeBag
    var disposeBag = DisposeBag()
    
    // MARK Life cycle
    init(reactor: SimpleViewReactor = SimpleViewReactor()) {
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
    func bind(reactor: SimpleViewReactor) {
        bind(state: reactor.state)
        bind(action: reactor.action)
    }
    
    private func bind(state: Observable<State>) {
        bindView(state: state)
        bindSceneView(state: state)
    }
    
    private func bind(action: ActionSubject<Action>) {
        bindView(action: action)
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
}
