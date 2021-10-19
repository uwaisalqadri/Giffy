//
//  String+Localized.swift
//  
//
//  Created by Uwais Alqadri on 10/17/21.
//

import Foundation
import SwiftUI

extension String {
  public func localized() -> String {
    let bundle = Bundle(identifier: "com.uwaisalqadri.Common") ?? .main
    let result = bundle.localizedString(forKey: self, value: nil, table: nil)
    return result
  }

  public func cgFloatValue() -> CGFloat? {
    guard let doubleValue = Double(self) else {
      return nil
    }
    return CGFloat(doubleValue/2)
  }
}

