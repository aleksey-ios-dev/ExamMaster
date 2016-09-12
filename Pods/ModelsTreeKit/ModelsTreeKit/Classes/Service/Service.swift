//
// Created by aleksey on 15.11.15.
// Copyright (c) 2015 aleksey chernish. All rights reserved.
//

import Foundation

public class Service {
  
  private unowned var locator: ServiceLocator
  
  public init(locator: ServiceLocator) {
    self.locator = locator
  }
  
  //At this point all services from surrounding are instantiated
  
  public func takeOff() {}
  
  public func prepareToClose() {}
  
}
