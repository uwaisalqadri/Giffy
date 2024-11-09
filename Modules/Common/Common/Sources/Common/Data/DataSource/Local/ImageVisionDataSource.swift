//
//  ImageVisionDataSource.swift
//
//
//  Created by Uwais Alqadri on 10/11/24.
//

import Core
import Combine
import Foundation
import CoreImage
import Vision
import SwiftUI

public struct ImageVisionDataSource: DataSource {
  public typealias Request = CIImage
  public typealias Response = ImageData

  public init() {}
  
  public func execute(request: CIImage?) async throws -> ImageData {
    let inputCIImage = request!
    let inputImage = UIImage(cgImage: render(ciImage: inputCIImage))
    let outputImage = self.removeImageBackground(input: inputCIImage)
    let imageData = ImageData(inputCIImage: inputCIImage, inputImage: inputImage, outputImage: outputImage)
    return imageData
  }
  
  private func removeImageBackground(input: CIImage) -> UIImage? {
    guard let maskedImage = removeBackground(from: input, croppedToInstanceExtent: true) else {
      return nil
    }
    return UIImage(cgImage: render(ciImage: maskedImage))
  }
  
  private func render(ciImage img: CIImage) -> CGImage {
    guard let cgImage = CIContext(options: nil).createCGImage(img, from: img.extent) else {
      fatalError("failed to render CIImage")
    }
    return cgImage
  }
  
  private func removeBackground(from image: CIImage, croppedToInstanceExtent: Bool) -> CIImage? {
    let request = VNGenerateForegroundInstanceMaskRequest()
    let handler = VNImageRequestHandler(ciImage: image)
    
    do {
      try handler.perform([request])
    } catch {
      print("Failed to perform vison request")
      return nil
    }
    
    guard let result = request.results?.first else {
      print("No subject observations found")
      return nil
    }
    
    do {
      let maskedImage = try result.generateMaskedImage(ofInstances: result.allInstances, from: handler, croppedToInstancesExtent: croppedToInstanceExtent)
      return CIImage(cvPixelBuffer: maskedImage)
    } catch {
      print("Failed to generate masked image")
      return nil
    }
  }
}

public extension UIImage {
  
  func scaleToFit(targetSize: CGSize = .init(width: 512, height: 512)) -> UIImage {
    let widthRatio = targetSize.width / size.width
    let heightRatio = targetSize.height / size.height
    
    let scaleFactor = min(widthRatio, heightRatio)
    
    let scaledImageSize = CGSize(
      width: size.width * scaleFactor,
      height: size.height * scaleFactor
    )
    
    let renderer = UIGraphicsImageRenderer(size: targetSize)
    let scaledImage = renderer.image { _ in
      self.draw(in: .init(
        origin: .init(
          x: (targetSize.width - scaledImageSize.width) / 2.0,
          y: (targetSize.height - scaledImageSize.height) / 2.0),
        size: scaledImageSize))
    }
    return scaledImage
  }
  
  func scaledPNGData() -> Data {
    let targetSize = CGSize(
      width: size.width / UIScreen.main.scale,
      height: size.height / UIScreen.main.scale)
    
    let renderer = UIGraphicsImageRenderer(size: targetSize)
    let resized = renderer.image { _ in
      self.draw(in: .init(origin: .zero, size: targetSize))
    }
    return resized.pngData()!
  }
  
  func scaledJPGData(compressionQuality: CGFloat = 0.5) -> Data {
    let targetSize = CGSize(
      width: size.width / UIScreen.main.scale,
      height: size.height / UIScreen.main.scale)
    
    let renderer = UIGraphicsImageRenderer(size: targetSize)
    let resized = renderer.image { _ in
      self.draw(in: .init(origin: .zero, size: targetSize))
    }
    return resized.jpegData(compressionQuality: compressionQuality)!
  }
}
