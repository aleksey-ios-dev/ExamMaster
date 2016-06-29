//
//  ServiceLocator.swift
//  SessionSwift
//
//  Created by aleksey on 10.10.15.
//  Copyright © 2015 aleksey chernish. All rights reserved.
//

import Foundation

public class ServiceLocator {
  
  private var services: [String: Any] = [:]
  
  public init() {}
  
  //Access
  
  public func registerService<T>(service: T) {
    let key = "\(T.self)"
    services[key] = service
  }
  
  public func getService<T>() -> T! {
    let key = "\(T.self)"
    return services[key] as! T
  }
  
  //Lifecycle
  
  func takeOff() {
    for service in services.values {
      if let service = service as? Service { service.takeOff() }
    }
  }
  
  func prepareToClose() {
    services.values.forEach { if let service = $0 as? Service { service.prepareToClose() } }
  }
  
}
