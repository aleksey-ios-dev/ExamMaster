//
//  RootModelsRouter.swift
//  ExamMaster
//
//  Created by aleksey on 29.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

class AppRootModelsRouter: RootModelsRouter {
  func modelFor(session session: Session) -> Model {
    switch session {
    case is UserSession:
      return MainFlow(parent: session)
    default:
      return LoginFlow(parent: session)
    }
  }
}