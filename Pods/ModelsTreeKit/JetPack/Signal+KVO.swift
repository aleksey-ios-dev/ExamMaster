//
//  Signal+KVO.swift
//  ModelsTreeKit
//
//  Created by aleksey on 06.06.16.
//  Copyright © 2016 aleksey chernish. All rights reserved.
//

import Foundation

private class KeyValueObserver: NSObject {
  
  typealias ObservingAction = (Any?) -> Void
  
  private weak var object: NSObject!
  private var blocks = [String: ObservingAction]()
  private var signals = [String: Any]()
  private var context: Int = 0
  
  init(object: NSObject) {
    self.object = object
    super.init()
  }
  
  //TODO: owner required
  fileprivate func _signalForKeyPath<T>(keyPath: String, owner: DeinitObservable) -> Observable<T?> {
    var signal = signals[keyPath]
    if signal == nil {
      signal = Observable<T?>()
      signals[keyPath] = signal
      startObservingKey(key: keyPath)
      
      blocks[keyPath] = { value in
        let castedSignal = signal as! Observable<T?>
        if let castedValue = value as? T {
          castedSignal.value = castedValue
        }
        else {
          castedSignal.value = nil
        }
      }
      
      owner.deinitSignal.subscribeNext { [weak self] in
        guard let _self = self else { return }
        for keyPath in _self.signals.keys {
          _self.object.removeObserver(_self, forKeyPath: keyPath, context: &_self.context)
        }
      }.put(into: pool)
    }
    
    return signal as! Observable<T?>
  }
  
  private func startObservingKey(key: String) {
    object.addObserver(self, forKeyPath: key, options: [.new, .initial], context: &context)
  }
  
  override private func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if context != &self.context { return }
    
    guard let keyPath = keyPath, let change = change else { return }
    
    if let value = change[NSKeyValueChangeKey.newKey] {
      blocks[keyPath]?(value)
    }
  }
  
}

extension NSObject {
  
  private struct AssociatedKeys {
    static var KeyValueObserverKey = "KeyValueObserverKey"
  }
  
  public func signalForKeyPath<T>(key: String, owner: DeinitObservable) -> Observable<T?> {
    return keyValueObserver._signalForKeyPath(keyPath: key, owner: owner)
  }
  
  private var keyValueObserver: KeyValueObserver {
    get {
      var wrapper = objc_getAssociatedObject(self, &AssociatedKeys.KeyValueObserverKey) as? KeyValueObserver
      
      if (wrapper == nil) {
        wrapper = KeyValueObserver(object: self)
        objc_setAssociatedObject(self, &AssociatedKeys.KeyValueObserverKey, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      }
      
      return wrapper!
    }
  }
  
}
