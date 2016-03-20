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

  var window: UIWindow? = UIWindow(frame: UIScreen.mainScreen().bounds)
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    
    SessionController.controller.configuration = SessionControllerConfiguration.appConfiguration()
    SessionController.controller.representationRouter = AppRootRepresentationRouter()
    SessionController.controller.sessionRouter = AppRootSessionRouter()
    SessionController.controller.modelRouter = AppRootModelRouter()
    SessionController.controller.serviceConfigurator = AppServiceConfigurator()
    SessionController.controller.navigationManager = AppNavigationManager(window: window)
    
    SessionController.controller.restoreLastOpenedOrStartLoginSession()
    
    return true
  }

}

