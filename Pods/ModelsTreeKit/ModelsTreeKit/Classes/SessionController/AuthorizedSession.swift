//
//  AuthorizedSession.swift
//  SessionSwift
//
//  Created by aleksey on 12.10.15.
//  Copyright © 2015 aleksey chernish. All rights reserved.
//

import Foundation

public class AuthorizedSession: Session {
  
  public required init(archivationProxy: ArchivationProxy) {
    super.init()
    if let credentialsProxy = archivationProxy["credentials"] as? ArchivationProxy {
      credentials = SessionCredentials(archivationProxy: credentialsProxy)
    }
  }

  required public init() {
      fatalError("initialization without parameters is not available")
  }

  public required init(params: SessionCompletionParams) {
    super.init(params: params)
  }
  
  public required init(parent: Model?) {
    super.init(parent: parent)
  }
  
}

extension AuthorizedSession: Archivable {
  
  public func archivationProxy() -> ArchivationProxy {
    var proxy = ArchivationProxy()
    proxy["credentials"] = credentials?.archivationProxy()
    
    return proxy
  }
  
}