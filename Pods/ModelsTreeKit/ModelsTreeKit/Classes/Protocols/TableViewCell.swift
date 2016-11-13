//
//  TableViewCell.swift
//  ModelsTreeKit
//
//  Created by aleksey on 21.11.15.
//  Copyright © 2015 aleksey chernish. All rights reserved.
//

import Foundation
import UIKit

public protocol HeightCalculatingCell {
  
  func height(forObject object: Any?, width: CGFloat, userInfo: [String: AnyObject]?) -> CGFloat
  
}

public protocol SizeCalculatingCell {
  
  func size(forObject object: Any?, userInfo: [String: AnyObject]?) -> CGSize
  
}