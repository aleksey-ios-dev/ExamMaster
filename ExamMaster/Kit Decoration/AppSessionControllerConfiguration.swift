//
//  AppServiceLocatorConfiguration.swift
//  ExamMaster
//
//  Created by aleksey on 27.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

extension SessionControllerConfiguration {
  
  static func appConfiguration() -> SessionControllerConfiguration {
    return SessionControllerConfiguration(
      keychainAccessKey: "ExamMaster",
      credentialsPrimaryKey: AppCredentialsKeys.Uid.rawValue)
  }
  
}