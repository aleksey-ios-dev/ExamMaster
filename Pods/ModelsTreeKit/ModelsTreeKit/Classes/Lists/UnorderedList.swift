//
//  UnorderedList.swift
//  SessionSwift
//
//  Created by aleksey on 15.10.15.
//  Copyright © 2015 aleksey chernish. All rights reserved.
//

import Foundation

enum ListChangeType {
  
  case Deletion, Insertion, Update, Move
  
}

public class UnorderedList<T where T: Hashable, T: Equatable>: Model {
  
  let beginUpdatesSignal = Pipe<Void>()
  let endUpdatesSignal = Pipe<Void>()
  let didChangeContentSignal = Pipe<(insertions: Set<T>, deletions: Set<T>, updates: Set<T>)>()
  let didReplaceContentSignal = Pipe<Set<T>>()
  
  public private(set) var objects = Set<T>()
  
  private var updatesPool = UpdatesPool<T>()
  
  public init(parent: Model?, objects: [T] = []) {
    super.init(parent: parent)
    
    self.objects = Set(objects)
  }
  
  public func performUpdates(updates: UnorderedList -> Void) {
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
  
  //Operations on objects. Use ONLY inside performBatchUpdate() call!
  
  public func delete(objects: [T]) {
    if objects.isEmpty { return }
    updatesPool.deletions.unionInPlace(Set(objects))
  }
  
  public func insert(objects: [T]) {
    if objects.isEmpty { return }
    updatesPool.insertions.unionInPlace(Set(objects))
  }
  
  //Call outside the batch update block. Informs subscriber that data should be reloaded
  //To perform batch-based replacement use removeAllObjects() and insert() methods within the batch update block
  
  public func replaceWith(objects: [T]) {
    self.objects = Set(objects)
    didReplaceContentSignal.sendNext(self.objects)
  }
  
  public func reset() {
    replaceWith([])
  }
  
  public func removeAllObjects() {
    delete(Array(objects))
  }
  
  public func didFinishFetchingObjects() {
  }
  
  //Private
  
  private func applyChanges() {
    updatesPool.optimizeFor(objects)
    objects.unionInPlace(updatesPool.insertions)
    objects.unionInPlace(updatesPool.updates)
    objects.subtractInPlace(updatesPool.deletions)
  }
  
  private func pushUpdates() {
    didChangeContentSignal.sendNext((
      insertions: updatesPool.insertions,
      deletions: updatesPool.deletions,
      updates: updatesPool.updates)
    )
  }
  
}

internal class UpdatesPool<T where T: protocol <Hashable, Equatable>> {
  
  var insertions = Set<T>()
  var deletions = Set<T>()
  var updates = Set<T>()
  
  func addObjects(objects: [T], forChangeType changeType: ListChangeType) {
    switch changeType {
    case .Insertion: insertions.unionInPlace(objects)
    case .Deletion: deletions.unionInPlace(objects)
    default: break
    }
  }
  
  func drain() {
    insertions = []
    deletions = []
    updates = []
  }
  
  func optimizeFor(objects: Set<T>) {
    optimizeDuplicatingEntries()
    updates.unionInPlace(insertions.intersect(objects))
    insertions.subtractInPlace(updates)
    deletions.intersectInPlace(objects)
  }
  
  func optimizeDuplicatingEntries() {
    let commonObjects = insertions.intersect(deletions)
    insertions.subtractInPlace(commonObjects)
    deletions.subtractInPlace(commonObjects)
  }
  
}
