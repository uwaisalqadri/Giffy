//
//  String+Localized.swift
//  
//
//  Created by Uwais Alqadri on 10/17/21.
//

import Foundation
import SwiftUI

extension String {  
  public var cgFloat: CGFloat {
    guard let doubleValue = Double(self) else {
      return 0.0
    }
    return CGFloat(doubleValue/2)
  }
}
