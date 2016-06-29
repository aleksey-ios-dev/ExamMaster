//
//  Disposable.swift
//  ModelsTreeKit
//
//  Created by aleksey on 05.06.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation

public protocol Disposable: class {
  
  func dispose()
  func deliverOnMainThread() -> Disposable
  func autodispose() -> Disposable
  func putInto(pool: AutodisposePool) -> Disposable
  func takeUntil(signal: Pipe<Void>) -> Disposable
  func ownedBy(object: DeinitObservable) -> Disposable
  
}