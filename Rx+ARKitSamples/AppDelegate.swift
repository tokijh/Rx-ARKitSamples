//
//  AppDelegate.swift
//  Rx+ARKitSamples
//
//  Created by 윤중현 on 2018. 10. 4..
//  Copyright © 2018년 tokijh. All rights reserved.
//

import UIKit
import Then
import SnapKit
import RxSwiftExtensions

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setup()
        return true
    }
    
    private func setup() {
        setupWindow()
    }
    
    // MARK Window
    var window: UIWindow?
    public private(set) lazy var navigationController = UINavigationController(rootViewController: self.rootViewController).then {
        $0.navigationBar.prefersLargeTitles = true
    }
    public private(set) lazy var rootViewController: UIViewController = SampleListViewController()
    
    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
