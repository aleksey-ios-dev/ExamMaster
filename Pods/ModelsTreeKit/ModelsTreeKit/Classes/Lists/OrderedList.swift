//
//  OrderedList.swift
//  ModelsTreeDemo
//
//  Created by Aleksey on 15.10.16.
//  Copyright © 2016 Aleksey Chernish. All rights reserved.
//

import Foundation

public class OrderedList<T where T: Hashable, T: Equatable>: Model {
  
  let beginUpdatesSignal = Pipe<Void>()
  let endUpdatesSignal = Pipe<Void>()
  let didChangeContentSignal = Pipe<(appendedObjects: [T], deletions: Set<T>, updates: Set<T>)>()
  let didReplaceContentSignal = Pipe<[T]>()
  
  public private(set) var objects = [T]() {
    didSet {
      objectsSet = Set(objects)
    }
  }
  
  public private(set) var objectsSet = Set<T>()
  
  private var updatesPool = OrderedListUpdatesPool<T>()
  
  public init(parent: Model?, objects: [T] = []) {
    super.init(parent: parent)
    
    self.objects = objects
  }
  
  public func performUpdates(updates: OrderedList -> Void) {
    beginUpdates()
    updates(self)
    endUpdates()
  }
  
  internal func beginUpdates() {
    beginUpdatesSignal.sendNext()
  }
  
  internal func endUpdates() {
    applyChanges()
    pushUpdates()
    updatesPool.drain()
    endUpdatesSignal.sendNext()
  }
  
  private func pushUpdates() {
    didChangeContentSignal.sendNext((
      appendedObjects: updatesPool.appendedObjects,
      deletions: updatesPool.deletions,
      updates: updatesPool.updates)
    )
  }
  
  public func replaceWith(objects: [T]) {
    self.objects = objects
    didReplaceContentSignal.sendNext(self.objects)
  }
  
  //Operations on objects. Use ONLY inside performBatchUpdate() call!
  
  public func append(objects: [T]) {
    updatesPool.appendedObjects += objects
  }
  
  public func delete(objects: [T]) {
    if objects.isEmpty { return }
    updatesPool.deletions.unionInPlace(objects)
  }
  
  public func update(objects: [T]) {
    if objects.isEmpty { return }
    updatesPool.updates.unionInPlace(objects)
  }
  
  private func applyChanges() {
    updatesPool.optimizeFor(objectsSet)
    objects = objects.filter { !self.updatesPool.deletions.contains($0) }
    objects = objects + updatesPool.appendedObjects
    objects = objects.map { return updatesPool.updates.objectEqualTo($0) ?? $0 }
  }
  
}

internal class OrderedListUpdatesPool<T where T: protocol <Hashable, Equatable>> {
  
  var appendedObjects = [T]()
  var deletions = Set<T>()
  var updates = Set<T>()
  
  func drain() {
    appendedObjects = []
    deletions = []
    updates = []
  }
  
  func optimizeFor(objects: Set<T>) {
    deletions.intersectInPlace(objects)
    updates.subtractInPlace(deletions)
    updates.intersectInPlace(objects)
    appendedObjects = appendedObjects.removeDuplicates().filter {
      !self.deletions.contains($0) && !objects.contains($0)
    }
  }
  
}
