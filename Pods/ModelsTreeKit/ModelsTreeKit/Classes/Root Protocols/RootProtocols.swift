//
//  Routers.swift
//  SessionSwift
//
//  Created by aleksey on 24.10.15.
//  Copyright © 2015 aleksey chernish. All rights reserved.
//

import Foundation


public protocol RootRepresentationRouter {
  
  func representationFor(session session: Session) -> AnyObject;
  
}

public protocol RootModelRouter {
  
  func modelFor(session session: Session) -> Model;
  
}

public protocol RootNavigationManager {
  
  func showRootRepresentation(representation: AnyObject) -> Void
  
}

public protocol SessionGenerator {
  
  func unauthorizedSessionType() -> Session.Type
  func authorizedSessionType() -> Session.Type
  
}

public protocol ServiceConfigurator {
  
  func configure(session: Session) -> Void
  
}
