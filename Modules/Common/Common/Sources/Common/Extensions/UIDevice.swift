//
//  UIDevice.swift
//  
//
//  Created by Uwais Alqadri on 19/9/23.
//

import Foundation
import UIKit

public extension UIDevice {
  static var isIpad: Bool {
    UIDevice.current.userInterfaceIdiom == .pad
  }
}
