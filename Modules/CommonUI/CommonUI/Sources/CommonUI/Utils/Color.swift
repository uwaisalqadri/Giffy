//
//  File.swift
//  
//
//  Created by Uwais Alqadri on 19/9/23.
//

import SwiftUI

public extension Color {
  struct Theme {
    public static var red = Color("col_red", bundle: Bundle.common)
    public static var green = Color("col_green", bundle: Bundle.common)
    public static var blueSky = Color("col_blue_sky", bundle: Bundle.common)
    public static var yellow = Color("col_yellow", bundle: Bundle.common)
    public static var purple = Color("col_purple", bundle: Bundle.common)
    public static var background = Color("col_background", bundle: Bundle.common)
  }
  
  static var randomColor: Color {
    switch Int.random(in: 0...5) {
    case 0:
      return .Theme.red
    case 1:
      return .Theme.green
    case 2:
      return .Theme.blueSky
    case 3:
      return .Theme.yellow
    case 4:
      return .Theme.purple
    default:
      return .accentColor
    }
  }
}
