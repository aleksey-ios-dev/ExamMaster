//
//  Session.swift
//  SessionSwift
//
//  Created by aleksey on 10.10.15.
//  Copyright © 2015 aleksey chernish. All rights reserved.
//

import Foundation

public typealias SessionCompletionParams = [String: AnyObject]

protocol SessionDelegate: class {
  
  func sessionDidPrepareToShowRootRepresenation(session: Session) -> Void
  func session(session: Session, didCloseWithParams params: Any?) -> Void
  func sessionDidOpen(session: Session) -> Void
  
}

public class Session: Model {
  
  public var services: ServiceLocator!
  public var credentials: SessionCredentials?
  
  private weak var controller: SessionDelegate?
  
  public required init() {
    super.init(parent: nil)
  }
  
  public required init(archivationProxy: ArchivationProxy) {
    super.init(parent: nil)
  }
  
  public required init(params: SessionCompletionParams) {
    super.init(parent: nil)
    credentials = SessionCredentials(params: params)
  }
  
  public func sessionDidLoad() {}
  
  func open(with controller: SessionController) {
    self.controller = controller
    self.services.takeOff()
    self.controller?.sessionDidOpen(session: self)
    self.controller?.sessionDidPrepareToShowRootRepresenation(session: self)
    sessionDidLoad()
  }
  
  public func close(withParams params: Any?) {
    sessionWillClose()
    services.prepareToClose()
    controller?.session(session: self, didCloseWithParams: params)
  }
  
}

