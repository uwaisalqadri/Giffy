//
//  File.swift
//  CommonUI
//
//  Created by Uwais Alqadri on 08/02/25.
//

import Foundation
import SDWebImage

public enum CacheImage {
  public static func downloadImage(from url: URL?) async throws -> Data? {
    return try await withCheckedThrowingContinuation { continuation in
      var isResumed = false
      
      SDWebImageManager.shared.loadImage(
        with: url,
        options: [.queryMemoryData, .progressiveLoad],
        progress: nil
      ) { _, data, error, _, _, _ in
        guard !isResumed else { return }
        
        if let error = error {
          isResumed = true
          continuation.resume(throwing: error)
          return
        }
        
        guard let data = data, let animatedImage = SDAnimatedImage(data: data) else {
          isResumed = true
          continuation.resume(throwing: NSError(domain: "Failed to decode animated image", code: -1))
          return
        }
        
        isResumed = true
        continuation.resume(returning: animatedImage.animatedImageData)
      }
    }
  }
}
