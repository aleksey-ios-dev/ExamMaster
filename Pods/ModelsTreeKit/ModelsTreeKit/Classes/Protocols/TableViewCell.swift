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
  
  func heightFor(object: Any?, width: CGFloat) -> CGFloat
  
}

public protocol SizeCalculatingCell {
  
  func sizeFor(object: Any?) -> CGSize
  
}