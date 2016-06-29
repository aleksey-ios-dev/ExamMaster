//
//  File.swift
//  SessionSwift
//
//  Created by aleksey on 15.10.15.
//  Copyright © 2015 aleksey chernish. All rights reserved.
//

import Foundation

enum ListChangeType {
  
  case Deletion, Insertion, Update, Move
  
}

public class List<T where T: Hashable, T: Equatable>: Model {
  
  public typealias FetchCompletionBlock = (success: Bool, response: [T]?, error: Error?) -> Void
  public typealias FetchBlock = (completion: FetchCompletionBlock, offset: Int) -> NSOperation?
  
  let beginUpdatesSignal = Pipe<Void>()
  let endUpdatesSignal = Pipe<Void>()
  let didChangeContentSignal = Pipe<(insertions: Set<T>, deletions: Set<T>, updates: Set<T>)>()
  let didReplaceContentSignal = Pipe<Set<T>>()
  
  public private(set) var objects = Set<T>()
  
  private var fetchBlock: FetchBlock?
  private var updatesPool = UpdatesPool<T>()
  
  private weak var fetchOperation: NSOperation?
  
  deinit {
    fetchOperation?.cancel()
  }
  
  public init(parent: Model?, array: [T] = []) {
    super.init(parent: parent)
    
    objects = Set(array)
  }
  
  public init(parent: Model?, fetchBlock: FetchBlock) {
    super.init(parent: parent)
    
    self.fetchBlock = fetchBlock
  }
  
  public func performUpdates(@autoclosure updates: Void -> Void ) {
    beginUpdatesSignal.sendNext()
    updates()
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
  
  //Fetch objects
  
  public func getNext() {
    getNextOffset(objects.count)
  }
  
  public func didFinishFetchingObjects() {
  }
  
  //Private
  
  private func getNextOffset(offset: Int) {
    fetchOperation?.cancel()
    let completion: FetchCompletionBlock = {[weak self] success, response, error in
      if let response = response {
        guard let strongSelf = self else { return }
        strongSelf.performUpdates(strongSelf.insert(response))
      }
      self?.didFinishFetchingObjects()
    }
    fetchOperation = fetchBlock?(completion: completion, offset: offset)
  }
  
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
  
  private(set) var insertions = Set<T>()
  private(set) var deletions = Set<T>()
  private(set) var updates = Set<T>()
  
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
    updates.unionInPlace(objects.intersect(insertions))
    insertions.subtractInPlace(updates)
    deletions.intersectInPlace(objects)
  }
  
  func optimizeDuplicatingEntries() {
    let commonObjects = insertions.intersect(deletions)
    insertions.subtractInPlace(commonObjects)
    deletions.subtractInPlace(commonObjects)
  }
  
}