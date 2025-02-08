//
//  File.swift
//  
//
//  Created by Uwais Alqadri on 08/12/24.
//

import SwiftUI

public extension Text {
  init(key localizable: Localizable) {
    self.init(localizable.localized)
  }
}
