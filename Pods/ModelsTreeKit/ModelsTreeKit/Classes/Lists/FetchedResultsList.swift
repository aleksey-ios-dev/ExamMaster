////
////  FetchedResultsList.swift
////  ModelsTreeDemo
////
////  Created by Aleksey on 27.08.16.
////  Copyright © 2016 Aleksey Chernish. All rights reserved.
////
//
//import Foundation
//import CoreData
//
//open class FetchedResultsList<T>: List<T> where T: Hashable, T: Equatable, T: NSFetchRequestResult {
//  
//  private let listener: FetchedResultsControllerListener<T>
//  
//  init(parent: Model?, fetchedResultsController: NSFetchedResultsController<T>) {
//    self.listener = FetchedResultsControllerListener(controller: fetchedResultsController)
//    
//    super.init(parent: parent)
//    
//    subscribe()
//    
//    try! fetchedResultsController.performFetch()
//  }
//  
//  private func subscribe() {
//    listener.beginUpdatesSignal.subscribeNext { [weak self] in
//      self?.beginUpdates()
//      }.owned(by: self)
//    
//    listener.endUpdatesSignal.subscribeNext { [weak self] in
//      self?.endUpdates()
//      }.owned(by: self)
//    
//    listener.changeObjectSignal.subscribeNext { [weak self] object, changeType in
//      guard let object = object as? T else { return }
//      
//      switch changeType {
//      case .delete:
//        self?.delete([object])
//      case .insert, .move, .update:
//        self?.insert([object])
//      }
//      }.owned(by: self)
//  }
//  
//}
//
//extension FetchedResultsControllerListener: NSFetchedResultsControllerDelegate {}
//
//private class FetchedResultsControllerListener<T>: NSObject where T: Hashable, T: Equatable, T: NSFetchRequestResult {
//  
//  private let fetchedResultsController: NSFetchedResultsController<T>
//  
//  let beginUpdatesSignal = Pipe<Void>()
//  let endUpdatesSignal = Pipe<Void>()
//  let changeObjectSignal = Pipe<(object: AnyObject, changeType: NSFetchedResultsChangeType)>()
//  
//  init(controller: NSFetchedResultsController<T>) {
//    self.fetchedResultsController = controller
//    
//    super.init()
//    
//    controller.delegate = self
//  }
//  
//  private func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//    beginUpdatesSignal.sendNext()
//  }
//  
//  private func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//    endUpdatesSignal.sendNext()
//  }
//  
//  private func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//    changeObjectSignal.sendNext((object: anObject as! T, changeType: type))
//  }
//  
//}
