//
//  CommonImage.swift
//  
//
//  Created by Uwais Alqadri on 10/20/21.
//

import Foundation
import UIKit

public struct Common {
  public static let isIpad = UIDevice.current.userInterfaceIdiom == .pad

  public static func loadBundle() -> Bundle {
    Bundle.module
  }

  public static func loadRandomColor() -> UIColor {
    return UIColor(
      red: .random(in: 0...1),
      green: .random(in: 0...1),
      blue: .random(in: 0...1),
      alpha: 1.0
    )
  }

}
