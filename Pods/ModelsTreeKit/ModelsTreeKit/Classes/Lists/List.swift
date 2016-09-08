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

public class List<T>: Model where T: Hashable, T: Equatable {
  
  public typealias FetchCompletionBlock = (_ success: Bool, _ response: [T]?, _ error: Error?) -> Void
  public typealias FetchBlock = (_ completion: FetchCompletionBlock, _ offset: Int) -> Operation?
  
  let beginUpdatesSignal = Pipe<Void>()
  let endUpdatesSignal = Pipe<Void>()
  let didChangeContentSignal = Pipe<(insertions: Set<T>, deletions: Set<T>, updates: Set<T>)>()
  let didReplaceContentSignal = Pipe<Set<T>>()
  
  public private(set) var objects = Set<T>()
  
  private var fetchBlock: FetchBlock?
  private var updatesPool = UpdatesPool<T>()
  
  private weak var fetchOperation: Operation?
  
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
  
  public func performUpdates(_ updates: @autoclosure (Void) -> Void ) {
    beginUpdates()
    updates()
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
    updatesPool.deletions.formUnion(Set(objects))
  }
  
  public func insert(objects: [T]) {
    if objects.isEmpty { return }
    updatesPool.insertions.formUnion(Set(objects))
  }
  
  //Call outside the batch update block. Informs subscriber that data should be reloaded
  //To perform batch-based replacement use removeAllObjects() and insert() methods within the batch update block
  
  public func replace(with objects: [T]) {
    self.objects = Set(objects)
    didReplaceContentSignal.sendNext(self.objects)
  }
  
  public func reset() {
    replace(with: [])
  }
  
  public func removeAllObjects() {
    delete(objects: Array(objects))
  }
  
  //Fetch objects
  
  public func getNext() {
    getNext(offset: objects.count)
  }
  
  public func didFinishFetchingObjects() {}
  
  //Private
  
  private func getNext(offset: Int = 0) {
    fetchOperation?.cancel()
    let completion: FetchCompletionBlock = {[weak self] success, response, error in
      if let response = response {
        guard let strongSelf = self else { return }
        strongSelf.performUpdates(strongSelf.insert(objects: response))
      }
      self?.didFinishFetchingObjects()
    }
    fetchOperation = fetchBlock?(completion, offset)
  }
  
  private func applyChanges() {
    updatesPool.optimize(for: objects)
    objects.formUnion(updatesPool.insertions)
    objects.formUnion(updatesPool.updates)
    objects.subtract(updatesPool.deletions)
  }
  
  private func pushUpdates() {
    didChangeContentSignal.sendNext((
      insertions: updatesPool.insertions,
      deletions: updatesPool.deletions,
      updates: updatesPool.updates)
    )
  }
  
}

internal class UpdatesPool<T> where T: Hashable & Equatable {
  
  var insertions = Set<T>()
  var deletions = Set<T>()
  var updates = Set<T>()
  
  func add(_ objects: [T], forChangeType changeType: ListChangeType) {
    switch changeType {
    case .Insertion: insertions.formUnion(objects)
    case .Deletion: deletions.formUnion(objects)
    default: break
    }
  }
  
  func drain() {
    insertions = []
    deletions = []
    updates = []
  }
  
  func optimize(for objects: Set<T>) {
    optimizeDuplicatingEntries()
    updates.formUnion(objects.intersection(insertions))
    insertions.subtract(updates)
    deletions.formIntersection(objects)
  }
  
  func optimizeDuplicatingEntries() {
    let commonObjects = insertions.intersection(deletions)
    insertions.subtract(commonObjects)
    deletions.subtract(commonObjects)
  }
  
}
