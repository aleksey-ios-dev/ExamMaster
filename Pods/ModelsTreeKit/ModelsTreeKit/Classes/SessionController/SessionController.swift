//
//  SessionController.swift
//  SessionSwift
//
//  Created by aleksey on 09.10.15.
//  Copyright © 2015 aleksey chernish. All rights reserved.
//

import Foundation

public class SessionController {
  
  //TODO: restore
//  private enum ArchiverErrors: Error, RawRepresentable {
//    case SessionArchivationFailed, NoSessionForKey
//  }
  
  public static let controller = SessionController()
  
  //Decoration on start
  
  public var configuration: SessionControllerConfiguration!
  public var navigationManager: RootNavigationManager!
  public var representationRouter: RootRepresentationRouter!
  public var modelRouter: RootModelRouter!
  public var sessionRouter: SessionGenerator!
  public var serviceConfigurator: ServiceConfigurator!
  
  private var activeSession: Session?
  private let userDefaults = UserDefaults.standard

  public func restoreLastOpenedOrStartAnonymousSession() {
    if let lastSession = lastOpenedAuthorizedSession { openSession(session: lastSession) }
    else { openSession(session: self.sessionRouter.unauthorizedSessionType().init()) }
  }
  
  fileprivate func openSession(session: Session) {
    activeSession = session
    serviceConfigurator.configure(session: session)
    session.open(with: self)
    
    if let userSession = session as? AuthorizedSession {
      lastOpenedAuthorizedSession = userSession
    }
  }
  
  //Storage
  
  var lastOpenedAuthorizedSession: AuthorizedSession? {
    set {
      do { try archiveUserSession(session: newValue) }
      catch {}
      
      let hash: Int? = newValue?.credentials?[configuration.credentialsPrimaryKey]?.hash
      let uidString: String? = hash == nil ? nil : String(hash!)
      
      userDefaults.setValue(uidString, forKey: configuration.keychainAccessKey)
      userDefaults.synchronize()
    }
    
    get {
      guard let key = userDefaults.value(forKey: configuration.keychainAccessKey) as? String else { return nil }
      do { return try archivedUserSessionForKey(key: key) }
      catch { fatalError() }
      
      return nil
    }
  }
  
  private func archiveUserSession(session: AuthorizedSession?) throws {
    guard
      let session = session,
      let sessionKey = session.credentials?[configuration.credentialsPrimaryKey] as! String?
      //TODO: restore
//    else { throw ArchiverErrors.SessionArchivationFailed }
      else { return }
    
    let sessionData = NSKeyedArchiver.archivedData(withRootObject: session.archivationProxy())
    let keychain = KeychainItemWrapper.init(identifier: String(sessionKey.hash), accessGroup: nil)
    keychain?.setObject(sessionData, forKey: kSecAttrService)
  }
  
  fileprivate func archivedUserSessionForKey(key: String?) throws -> AuthorizedSession {
    guard
      let sessionData = KeychainItemWrapper(identifier: key , accessGroup: nil).object(forKey: kSecAttrService) as? NSData,
      let sessionProxy = NSKeyedUnarchiver.unarchiveObject(with: sessionData as Data) as? ArchivationProxy
    //TODO: restore
//    else { throw ArchiverErrors.NoSessionForKey }
    else { throw NSError() }

    return sessionRouter.authorizedSessionType().init(archivationProxy: sessionProxy) as! AuthorizedSession
  }
  
}

extension SessionController: SessionDelegate {
  
  func sessionDidOpen(session: Session) {}
  
  func session(session: Session, didCloseWithParams params: Any?) {
    guard let _ = session as? UnauthorizedSession, let loginParams = params as? SessionCompletionParams else {
      lastOpenedAuthorizedSession = nil
      openSession(session: sessionRouter.unauthorizedSessionType().init() as! UnauthorizedSession)
      
      return
    }
    
    do {
      let uidString = loginParams[configuration.credentialsPrimaryKey.rawValue]!
      let session = try archivedUserSessionForKey(key: String(uidString.hash))
      openSession(session: session)
    } catch {
      openSession(session: sessionRouter.authorizedSessionType().init(params: loginParams))
    }
  }
  
  func sessionDidPrepareToShowRootRepresenation(session: Session) {
    let representation = representationRouter.representation(for: session)
    let model = modelRouter.model(for: session)

    if let assignable = representation as? RootModelAssignable { assignable.assignRootModel(model: model) }
    if let deinitObservable = representation as? DeinitObservable { model.applyRepresentation(representation: deinitObservable) }
    
    navigationManager.show(rootRepresentation: representation)
  }
  
}
