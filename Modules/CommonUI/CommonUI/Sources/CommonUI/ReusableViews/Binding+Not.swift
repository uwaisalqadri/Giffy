//
//  Binding.swift
//
//
//  Created by Uwais Alqadri on 10/11/24.
//

import SwiftUI

public extension Binding where Value == Bool {
  var not: Binding<Value> {
    Binding<Value>(
      get: { !self.wrappedValue },
      set: { self.wrappedValue = !$0 }
    )
  }
}
