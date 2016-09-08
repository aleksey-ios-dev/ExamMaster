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
  typealias UpdateAction = (Void) -> Void
  
  public var nibNameForObjectMatching: ((ObjectType) -> String)!
  
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
    }.put(into: pool)
    
    dataSource.endUpdatesSignal.subscribeNext { [weak self] in
      guard let strongSelf = self else { return }
      strongSelf.updateActions.forEach { $0() }
    }.put(into: pool)
    
    dataSource.reloadDataSignal.subscribeNext { [weak self] in
      guard let strongSelf = self else { return }
      
      UIView.animate(withDuration: 0.1, animations: {
        strongSelf.collectionView.alpha = 0},
        completion: { completed in
          strongSelf.collectionView.reloadData()
          UIView.animate(withDuration: 0.2, animations: {
            strongSelf.collectionView.alpha = 1
        })
      })
    }.put(into: pool)
    
    dataSource.didChangeObjectSignal.subscribeNext { [weak self] object, changeType, fromIndexPath, toIndexPath in
      guard let strongSelf = self else {
        return
      }
      
      switch changeType {
      case .Insertion:
        if let toIndexPath = toIndexPath {
          strongSelf.updateActions.append() { [weak strongSelf] in
            strongSelf?.collectionView.insertItems(at: [toIndexPath as IndexPath])
          }
        }
      case .Deletion:
        strongSelf.updateActions.append() { [weak strongSelf] in
          if let fromIndexPath = fromIndexPath {
            strongSelf?.collectionView.deleteItems(at: [fromIndexPath as IndexPath])
          }
        }
      case .Update:
        strongSelf.updateActions.append() { [weak strongSelf] in
          if let indexPath = toIndexPath {
            strongSelf?.collectionView.reloadItems(at: [indexPath as IndexPath])
          }
        }
      case .Move:
        strongSelf.updateActions.append() { [weak strongSelf] in
          if let fromIndexPath = fromIndexPath, let toIndexPath = toIndexPath {
            strongSelf?.collectionView.moveItem(at: fromIndexPath as IndexPath, to: toIndexPath as IndexPath)
          }
        }
      }
    }.put(into: pool)
    
    dataSource.didChangeSectionSignal.subscribeNext { [weak self] changeType, fromIndex, toIndex in
      guard let strongSelf = self else { return }
      
      switch changeType {
      case .Insertion:
        strongSelf.updateActions.append() { [weak strongSelf] in
          if let toIndex = toIndex {
            strongSelf?.collectionView.insertSections(NSIndexSet(index: toIndex) as IndexSet)
          }
        }
      case .Deletion:
        if let fromIndex = fromIndex {
          strongSelf.updateActions.append() { [weak strongSelf] in
            strongSelf?.collectionView.deleteSections(NSIndexSet(index: fromIndex) as IndexSet)
          }
        }
      default:
        break
      }
    }.put(into: pool)
  }
  
  public func register<U: ObjectConsuming>(cellClass: U.Type) where U.ObjectType == ObjectType {
    let identifier = String(describing: cellClass)
    let nib = UINib(nibName: identifier, bundle: nil)
    collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    instances[identifier] = nib.instantiate(withOwner: self, options: nil).last as? UICollectionViewCell
    
    mappings[identifier] = { object, cell, _ in
      if let consumer = cell as? U {
        consumer.applyObject(object: object)
      }
    }
  }
  
  //UICollectionViewDataSource
  
  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return dataSource.numberOfSections()
  }
  
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dataSource.numberOfObjects(inSection: section)
  }
  
  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let object = dataSource.object(at: indexPath)
    
    let identifier = nibNameForObjectMatching(object)
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath as IndexPath)
    identifiersForIndexPaths[indexPath as NSIndexPath] = identifier

    
    willSetObjectSignal.sendNext(cell)
    let mapping = mappings[identifier]!
    mapping(object, cell, indexPath as NSIndexPath)
    didSetObjectSignal.sendNext(cell)
    
    return cell
  }
  
  public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    willDisplayCellSignal.sendNext(cell)
  }
  
  public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    didEndDisplayingCell.sendNext(cell)
  }
  
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let object = dataSource.object(at: indexPath)
    let identifier = nibNameForObjectMatching(object)
    
    if let cell = instances[identifier] as? SizeCalculatingCell {
      willCalculateSizeSignal.sendNext(instances[identifier]!)
      return cell.size(for: dataSource.object(at: indexPath))
    }
    
    if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
      return flowLayout.itemSize
    }
    
    return CGSize.zero;
  }
  
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath)
    let object = dataSource.object(at: indexPath)
    didSelectCellSignal.sendNext((cell: cell, object: object))
  }
}
