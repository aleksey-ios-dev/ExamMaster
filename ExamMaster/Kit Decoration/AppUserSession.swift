//
//  AppUserSession.swift
//  SessionSwift
//
//  Created by aleksey on 24.10.15.
//  Copyright © 2015 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

class AppUserSession: UserSession {
  
  override func sessionDidLoad() {
    registerForError(NetworkErrors.BadToken, inDomain: ErrorDomains.Network)
  }
  
  override func handleError(error: Error) {
    if error == Error(domain: ErrorDomains.Network, code: NetworkErrors.BadToken) {
      closeWithParams(nil)
    }
  }
  
  override func raiseError(error: Error) {
    super.raiseError(error)
    print("NO HANDLING FOR \(error)")
  }
  
}
