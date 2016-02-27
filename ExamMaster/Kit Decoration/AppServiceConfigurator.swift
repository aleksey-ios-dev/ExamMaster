 //
//  ServiceConfigurator.swift
//  SessionSwift
//
//  Created by aleksey on 24.10.15.
//  Copyright © 2015 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit

class AppServiceConfigurator: ServicesConfigurator {
    func configure(session: Session) {
        let locator = ServiceLocator()
        
        switch session {
        case is UserSession:
          break
//            locator.registerService(Defaults(locator: locator), forKey: ServiceKey.Defaults.rawValue)
//            locator.registerService(DataStorage(locator: locator), forKey: ServiceKey.DataStorage.rawValue)
//            locator.registerService(InitializationService(locator: locator), forKey: ServiceKey.Initialization.rawValue)
//            locator.registerService(UserStore(locator: locator), forKey: ServiceKey.UserStore.rawValue)
//            locator.registerService(DataLoader(locator: locator), forKey: ServiceKey.DataLoader.rawValue)
//            locator.registerService(ScanResultsProcessor(locator: locator), forKey: ServiceKey.ScanResultsProcessor.rawValue)
        case is LoginSession:
//            locator.registerService(DataStorage(locator: locator), forKey: ServiceKey.DataStorage.rawValue)
//            locator.registerService(UserStore(locator: locator), forKey: ServiceKey.UserStore.rawValue)
          break
        default:
            break
        }
        
        session.services = locator
    }
}
