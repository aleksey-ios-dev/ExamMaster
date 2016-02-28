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
  
  override init(params: SessionCompletionParams) {
    super.init(params: params)
  }
  
  required init(archivationProxy: ArchivationProxy) {
    super.init(archivationProxy: archivationProxy)
  }
  
  override func raiseError(error: Error) {
    if error == Error(domain: NetworkErrorDomain(), code: NetworkErrorDomain.Errors.BadToken) {
      print("\(self): Bad token received, closing")
      closeWithParams(nil)
    }
  }
}
