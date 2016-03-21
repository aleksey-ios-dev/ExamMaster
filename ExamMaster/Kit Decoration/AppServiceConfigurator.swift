 //
//  AppServiceConfigurator.swift
//  SessionSwift
//
//  Created by aleksey on 24.10.15.
//  Copyright © 2015 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

class AppServiceConfigurator: ServiceConfigurator {
  
    func configure(session: Session) {
        let locator = ServiceLocator()
        
        switch session {
        case is AuthorizedSession:
          locator.registerService(APIClient(locator: locator))
          
        case is UnauthorizedSession:
          locator.registerService(AuthorizationClient(locator: locator))
          
        default:
            break
        }
        
        session.services = locator
    }
  
}
