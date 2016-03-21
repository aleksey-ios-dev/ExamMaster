//
//  AppSessionRouter.swift
//  SessionSwift
//
//  Created by aleksey on 24.10.15.
//  Copyright © 2015 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

class AppSessionRouter: SessionGenerator {

  func unauthorizedSessionType() -> Session.Type {
    return UnauthorizedSession.self
  }
  
  func authorizedSessionType() -> Session.Type {
    return AppAuthorizedSession.self
  }

}