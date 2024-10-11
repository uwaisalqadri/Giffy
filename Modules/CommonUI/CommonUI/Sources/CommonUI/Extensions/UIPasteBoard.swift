//
//  File.swift
//  
//
//  Created by Uwais Alqadri on 28/4/24.
//

import Foundation
import UIKit
import UniformTypeIdentifiers

public extension Data {
  func copyGifClipboard() {
    UIPasteboard.general.setData(self, forPasteboardType: UTType.gif.identifier)
  }
}
