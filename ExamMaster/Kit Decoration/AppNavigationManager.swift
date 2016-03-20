//
//  AppNavigationManager.swift
//  SessionSwift
//
//  Created by aleksey on 10.10.15.
//  Copyright © 2015 aleksey chernish. All rights reserved.
//

import UIKit
import ModelsTreeKit

class AppNavigationManager: RootNavigationManager {
    private var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window

        self.window?.rootViewController = transitionController
        window?.makeKeyAndVisible()
    }
    
    private let transitionController = TSTTransitionViewController()
    
    func showRootRepresentation(representation: AnyObject) {
        if let controller = representation as? UIViewController {
            transitionController.showViewController(controller, animated: true)
        }
    }
}