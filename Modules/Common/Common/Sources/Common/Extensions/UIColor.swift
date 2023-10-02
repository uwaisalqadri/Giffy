//
//  File.swift
//  
//
//  Created by Uwais Alqadri on 19/9/23.
//

import SwiftUI

public extension Color {
  static var randomColor: Color {
    switch Int.random(in: 0...5) {
    case 0:
      return Color("Red", bundle: Bundle.common)
    case 1:
      return Color("Green", bundle: Bundle.common)
    case 2:
      return Color("Blue Sky", bundle: Bundle.common)
    case 3:
      return Color("Yellow", bundle: Bundle.common)
    case 4:
      return Color("Purple", bundle: Bundle.common)
    default:
      return .accentColor
    }
  }
}
