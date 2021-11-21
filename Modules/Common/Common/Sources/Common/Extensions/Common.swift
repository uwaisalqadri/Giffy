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

  public static func loadImage(named name: String) -> UIImage {
    UIImage(named: name, in: Bundle.module, compatibleWith: nil)!
  }
}
