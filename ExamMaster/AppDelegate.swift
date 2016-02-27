//
//  AppDelegate.swift
//  ExamMaster
//
//  Created by aleksey on 27.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import UIKit
import ModelsTreeKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    SessionController.controller.representationsRouter = AppRootRepresentationsRouter()
    SessionController.controller.modelsRouter = AppRootModelsRouter()
    SessionController.controller.sessionsRouter = AppRootSessionsRouter()
    SessionController.controller.servicesConfigurator = AppServiceConfigurator()
    SessionController.controller.navigationManager = AppNavigationManager(window: window)
    
    SessionController.controller.restoreLastOpenedOrStartLoginSession()

    return true
  }

}

