//
//  CollectionViewAdapter.swift
//  ModelsTreeKit
//
//  Created by aleksey on 06.12.15.
//  Copyright © 2015 aleksey chernish. All rights reserved.
//

import Foundation
import UIKit

public class CollectionViewAdapter <ObjectType>: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  typealias DataSourceType = ObjectsDataSource<ObjectType>
  typealias UpdateAction = Void -> Void
  
  public var nibNameForObjectMatching: (ObjectType -> String)!
  
  public let didSelectCellSignal = Pipe<(cell: UICollectionViewCell?, object: ObjectType?)>()
  public let willDisplayCellSignal = Pipe<UICollectionViewCell>()
  public let willCalculateSizeSignal = Pipe<UICollectionViewCell>()
  public let didEndDisplayingCell = Pipe<UICollectionViewCell>()
  public let willSetObjectSignal = Pipe<UICollectionViewCell>()
  public let didSetObjectSignal = Pipe<UICollectionViewCell>()
  
  private weak var collectionView: UICollectionView!

  private var dataSource: ObjectsDataSource<ObjectType>!
  private var instances = [String: UICollectionViewCell]()
  private var identifiersForIndexPaths = [NSIndexPath: String]()
  private var mappings: [String: (ObjectType, UICollectionViewCell, NSIndexPath) -> Void] = [:]
  private var updateActions = [UpdateAction]()
  
  public init(dataSource: ObjectsDataSource<ObjectType>, collectionView: UICollectionView) {
    super.init()
    
    self.collectionView = collectionView
    collectionView.dataSource = self
    collectionView.delegate = self
    
    self.dataSource = dataSource
    
    dataSource.beginUpdatesSignal.subscribeNext { [weak self] in
      self?.updateActions.removeAll()
    }.putInto(pool)
    
    dataSource.endUpdatesSignal.subscribeNext { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.updateActions.forEach { $0() }
    }.putInto(pool)
    
    dataSource.reloadDataSignal.subscribeNext { [weak self] in
      guard let strongSelf = self else { return }
      
      UIView.animateWithDuration(0.1, animations: {
        strongSelf.collectionView.alpha = 0},
        completion: { completed in
          strongSelf.collectionView.reloadData()
          UIView.animateWithDuration(0.2, animations: {
            strongSelf.collectionView.alpha = 1
        })
      })
    }.putInto(pool)
    
    dataSource.didChangeObjectSignal.subscribeNext { [weak self] object, changeType, fromIndexPath, toIndexPath in
      guard let strongSelf = self else {
        return
      }
      
      switch changeType {
      case .Insertion:
        if let toIndexPath = toIndexPath {
          strongSelf.updateActions.append() { [weak strongSelf] in
            strongSelf?.collectionView.insertItemsAtIndexPaths([toIndexPath])
          }
        }
      case .Deletion:
        strongSelf.updateActions.append() { [weak strongSelf] in
          if let fromIndexPath = fromIndexPath {
            strongSelf?.collectionView.deleteItemsAtIndexPaths([fromIndexPath])
          }
        }
      case .Update:
        strongSelf.updateActions.append() { [weak strongSelf] in
          if let indexPath = toIndexPath {
            strongSelf?.collectionView.reloadItemsAtIndexPaths([indexPath])
          }
        }
      case .Move:
        strongSelf.updateActions.append() { [weak strongSelf] in
          if let fromIndexPath = fromIndexPath, let toIndexPath = toIndexPath {
            strongSelf?.collectionView.moveItemAtIndexPath(fromIndexPath, toIndexPath: toIndexPath)
          }
        }
      }
    }.putInto(pool)
    
    dataSource.didChangeSectionSignal.subscribeNext { [weak self] changeType, fromIndex, toIndex in
      guard let strongSelf = self else { return }
      
      switch changeType {
      case .Insertion:
        strongSelf.updateActions.append() { [weak strongSelf] in
          if let toIndex = toIndex {
            strongSelf?.collectionView.insertSections(NSIndexSet(index: toIndex))
          }
        }
      case .Deletion:
        if let fromIndex = fromIndex {
          strongSelf.updateActions.append() { [weak strongSelf] in
            strongSelf?.collectionView.deleteSections(NSIndexSet(index: fromIndex))
          }
        }
      default:
        break
      }
    }.putInto(pool)
  }
  
  public func registerCellClass<U: ObjectConsuming where U.ObjectType == ObjectType>(cellClass: U.Type) {
    let identifier = String(cellClass)
    let nib = UINib(nibName: identifier, bundle: nil)
    collectionView.registerNib(nib, forCellWithReuseIdentifier: identifier)
    instances[identifier] = nib.instantiateWithOwner(self, options: nil).last as? UICollectionViewCell
    
    mappings[identifier] = { object, cell, _ in
      if let consumer = cell as? U {
        consumer.applyObject(object)
      }
    }
  }
  
  //UICollectionViewDataSource
  
  public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return dataSource.numberOfSections()
  }
  
  public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dataSource.numberOfObjectsInSection(section)
  }
  
  public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    let object = dataSource.objectAtIndexPath(indexPath)!;
    
    let identifier = nibNameForObjectMatching(object)
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
    identifiersForIndexPaths[indexPath] = identifier

    
    willSetObjectSignal.sendNext(cell)
    let mapping = mappings[identifier]!
    mapping(object, cell, indexPath)
    didSetObjectSignal.sendNext(cell)
    
    return cell
  }
  
  public func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
    willDisplayCellSignal.sendNext(cell)
  }
  
  public func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
    didEndDisplayingCell.sendNext(cell)
  }
  
  public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    let identifier = nibNameForObjectMatching(dataSource.objectAtIndexPath(indexPath)!)
    
    if let cell = instances[identifier] as? SizeCalculatingCell {
      willCalculateSizeSignal.sendNext(instances[identifier]!)
      return cell.sizeFor(dataSource.objectAtIndexPath(indexPath))
    }
    
    if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
      return flowLayout.itemSize
    }
    
    return CGSizeZero;
  }
  
  public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    didSelectCellSignal.sendNext(cell: collectionView.cellForItemAtIndexPath(indexPath), object: dataSource.objectAtIndexPath(indexPath))
  }
}
