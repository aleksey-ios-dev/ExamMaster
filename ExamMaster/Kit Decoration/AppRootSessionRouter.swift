//
//  AppRootSessionRouter.swift
//  SessionSwift
//
//  Created by aleksey on 24.10.15.
//  Copyright © 2015 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

class AppRootSessionRouter: SessionGenerator {

  func classOfAnonymousSession() -> Session.Type {
    return AppLoginSession.self
  }
  
  func classOfAuthorizedSession() -> Session.Type {
    return AppUserSession.self
  }

}