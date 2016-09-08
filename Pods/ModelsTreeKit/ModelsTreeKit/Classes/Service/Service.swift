//
// Created by aleksey on 15.11.15.
// Copyright (c) 2015 aleksey chernish. All rights reserved.
//

import Foundation

open class Service {
  
  public let locator: ServiceLocator
  
  public init(locator: ServiceLocator) {
    self.locator = locator
  }
  
  //At this point all services from surrounding are instantiated
  
  open func takeOff() {}
  
  open func prepareToClose() {}
  
}
