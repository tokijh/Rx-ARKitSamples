//
//  BaseNavigationController.swift
//  Rx+ARKitSamples
//
//  Created by 윤중현 on 06/10/2018.
//  Copyright © 2018 tokijh. All rights reserved.
//

import UIKit
import RxSwift

class BaseNavigationController: UINavigationController {
    // MARK DisposeBag
    var disposeBag = DisposeBag()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        setupInteractivePopGesture()
    }
    
    // MARK InteractivePopGesture
    private func setupInteractivePopGesture() {
        bindInteractivePopGesture()
    }
    
    private func updateInteractivePopGesture() {
        interactivePopGestureRecognizer?.delegate = self
    }
    
    private func bindInteractivePopGesture() {
        rx.methodInvoked(#selector(UINavigationController.setNavigationBarHidden(_:animated:)))
            .map({ value -> (Bool) in
                let hidden = try castOrThrow(Bool.self, value[0])
                return hidden
            })
            .filter({ $0 })
            .asVoid()
            .subscribe(onNext: { [weak self] in
                self?.updateInteractivePopGesture()
            })
            .disposed(by: disposeBag)
    }
}

extension BaseNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
