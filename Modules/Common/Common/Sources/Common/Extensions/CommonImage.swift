//
//  CommonImage.swift
//  
//
//  Created by Uwais Alqadri on 10/20/21.
//

import Foundation
import UIKit

public func CommonImage(named name: String) -> UIImage {
  UIImage(named: name, in: Bundle.module, compatibleWith: nil)!
}
