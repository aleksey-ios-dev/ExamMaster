//
//  AppAuthorizedSession.swift
//  SessionSwift
//
//  Created by aleksey on 24.10.15.
//  Copyright © 2015 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

class AppAuthorizedSession: AuthorizedSession {
  
  override func sessionDidLoad() {
    register(for: NetworkError.BadToken)
  }
  
  override func handle(error: ModelTreeError) {
    guard error.code is NetworkError else { return }
    close(withParams: nil)
  }
  
}
