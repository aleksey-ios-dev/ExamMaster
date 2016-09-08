//
//  UnauthorizedSession.swift
//  SessionSwift
//
//  Created by aleksey on 12.10.15.
//  Copyright © 2015 aleksey chernish. All rights reserved.
//

import Foundation

open class UnauthorizedSession: Session {
  
  public required init() {
    super.init()
  }
  
  required public init(archivationProxy: ArchivationProxy) {
    fatalError()
  }
  
  public required init(params: SessionCompletionParams) {
    fatalError("init(params:) has not been implemented")
  }
  
}
