//
//  Sticker.swift
//
//
//  Created by Uwais Alqadri on 10/11/24.
//

import Foundation
import SwiftUI

public enum StickerState {
  case none
  case generating
  case completed(ImageData)
  case failure(Error)
}

public struct Sticker: Identifiable, Equatable {
  public static func == (lhs: Sticker, rhs: Sticker) -> Bool {
    lhs.id == rhs.id
  }
    
  public let id = UUID()
  public var pos: Int = 0
  public var state = StickerState.none
  
  public init(pos: Int = 0, state: StickerState = StickerState.none) {
    self.pos = pos
    self.state = state
  }
  
  public var imageData: ImageData? {
    if case let .completed(imageData) = state {
      return imageData
    }
    return nil
  }
  
  public var isGeneratingImage: Bool {
    if case .generating = state {
      return true
    }
    return false
  }
  
  public var inputImage: Image? {
    guard let imageData else { return nil }
    return Image(uiImage: imageData.inputImage)
  }
  
  public var outputImage: Image? {
    guard let imageData, let outputImage = imageData.outputImage else { return nil }
    return Image(uiImage: outputImage)
  }
  
  public var errorText: String? {
    if case let .failure(error) = state {
      return error.localizedDescription
    }
    return nil
  }
  
}
