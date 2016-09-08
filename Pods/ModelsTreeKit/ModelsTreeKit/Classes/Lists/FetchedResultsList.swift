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
//class FetchedResultsList<T where T: Hashable, T: Equatable>: List<T> {
//  
//  private let listener: FetchedResultsControllerListener
//  
//  init(parent: Model?, fetchedResultsController: NSFetchedResultsController) {
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
//    }.ownedBy(self)
//    
//    listener.endUpdatesSignal.subscribeNext { [weak self] in
//      self?.endUpdates()
//    }.ownedBy(self)
//    
//    listener.changeObjectSignal.subscribeNext { [weak self] object, changeType in
//      guard let object = object as? T else { return }
//      
//      switch changeType {
//      case .Delete:
//        self?.delete([object])
//      case .Insert, .Move, .Update:
//        self?.insert([object])
//      }
//    }.ownedBy(self)
//  }
//  
//}
//
//private class FetchedResultsControllerListener: NSObject {
//  
//  private let fetchedResultsController: NSFetchedResultsController<AnyObject>
//  
//  let beginUpdatesSignal = Pipe<Void>()
//  let endUpdatesSignal = Pipe<Void>()
//  let changeObjectSignal = Pipe<(object: AnyObject, changeType: NSFetchedResultsChangeType)>()
//  
//  init(controller: NSFetchedResultsController) {
//    self.fetchedResultsController = controller
//    
//    super.init()
//    
//    controller.delegate = self
//  }
//  
//}
//
//extension FetchedResultsControllerListener: NSFetchedResultsControllerDelegate {
//  
//  @objc
//  private func controllerWillChangeContent(controller: NSFetchedResultsController) {
//    beginUpdatesSignal.sendNext()
//  }
//  
//  @objc
//  private func controllerDidChangeContent(controller: NSFetchedResultsController) {
//    endUpdatesSignal.sendNext()
//  }
//  
//  @objc
//  private func controller(
//    controller: NSFetchedResultsController,
//    didChangeObject anObject: AnyObject,
//    atIndexPath indexPath: NSIndexPath?,
//    forChangeType type: NSFetchedResultsChangeType,
//    newIndexPath: NSIndexPath?) {
//    changeObjectSignal.sendNext((object: anObject, changeType: type))
//  }
//  
//}
