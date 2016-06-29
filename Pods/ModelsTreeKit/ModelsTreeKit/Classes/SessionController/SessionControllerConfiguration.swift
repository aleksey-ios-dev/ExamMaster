//
//  SessionControllerConfiguration.swift
//  ModelsTreeKit
//
//  Created by aleksey on 27.02.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation

public struct SessionControllerConfiguration {
  
  var keychainAccessKey: String
  var credentialsPrimaryKey: CredentialsKey
  
  public init(keychainAccessKey: String, credentialsPrimaryKey: CredentialsKey) {
    self.keychainAccessKey = keychainAccessKey
    self.credentialsPrimaryKey = credentialsPrimaryKey
  }
  
}