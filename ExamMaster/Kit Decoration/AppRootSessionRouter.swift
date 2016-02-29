//
//  AppModelsRouter.swift
//  SessionSwift
//
//  Created by aleksey on 24.10.15.
//  Copyright © 2015 aleksey chernish. All rights reserved.
//

import Foundation
import ModelsTreeKit


class AppRootSessionsRouter: SessionsGenerator {
    func newLoginSession() -> LoginSession {
        return AppLoginSession()
    }
    
    func newUserSessionFrom(proxy: ArchivationProxy) -> UserSession {
        return AppUserSession(archivationProxy: proxy)
    }
    
    func newUserSessionWithParams(params: SessionCompletionParams) -> UserSession {
        return AppUserSession(params: params)
    }
}