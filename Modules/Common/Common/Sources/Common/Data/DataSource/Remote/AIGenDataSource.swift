//
//  AIGenDataSource.swift
//
//
//  Created by Uwais Alqadri on 10/11/24.
//

import Core
import Combine
import Foundation
import CoreImage
import XCAOpenAIClient
import SwiftUI

// TODO: Complete Generation
public struct AIGenDataSource: DataSource {
  public typealias Request = CIImage
  public typealias Response = ImageData

  private let openAIClient = OpenAIClient(apiKey: "API_KEY")
  public var gpt4VisionPromptTask: Task<Void, Never>?
  public var selectedAIGenerateOption = AIGenerateOption.textPrompt
  public var selectedGPT4VisionSourceImage: UIImage?
  public var gpt4PromptPhase = GPT4VisionPromptPhase.initial
  public var promptText = ""
  
  public var isPromptValid: Bool {
    switch selectedAIGenerateOption {
    case .gpt4Vision: return selectedGPT4VisionSourceImage != nil
    case .textPrompt: return promptText.trimmingCharacters(in: .whitespacesAndNewlines).count > 1
    }
  }
  
  public var isPromptingGPT4Vision: Bool {
    if case .prompting = gpt4PromptPhase {
      return true
    }
    return false
  }
  
  public init() {}
  
  public func execute(request: CIImage?) async throws -> ImageData {
    return ImageData(inputImage: UIImage())
  }
  
//  private func generateDallE3ImagesInBatch() {
//    guard isPromptValid else { return }
//    gpt4VisionPromptTask?.cancel()
//    switch selectedAIGenerateOption {
//    case .textPrompt:
//      (0..<Int(imagesInBatch)).forEach { index in
//        self.stickers[index].cancelOngoingTask()
//        generateDallE3Image(promptText: self.promptText, sticker: self.stickers[index])
//      }
//      
//    case .gpt4Vision:
//      gpt4VisionPromptTask = Task { @MainActor in
//        guard let image = self.selectedGPT4VisionSourceImage else { return }
//        do {
//          self.gpt4PromptPhase = .prompting
//          let promptText = try await openAIClient.promptChatGPTVision(imageData: image.scaleToFit(targetSize: .init(width: 512, height: 512)).scaledJPGData(), detail: .high)
//          try Task.checkCancellation()
//          self.gpt4PromptPhase = .success(promptText)
//          print(promptText)
//          (0..<Int(imagesInBatch)).forEach { index in
//            self.stickers[index].cancelOngoingTask()
//            generateDallE3Image(promptText: promptText, sticker: self.stickers[index])
//          }
//        } catch {
//          if Task.isCancelled { return }
//          self.gpt4PromptPhase = .failure(error)
//          print(error.localizedDescription)
//        }
//      }
//    }
//  }
//
//  public func generateDallE3ImageTask(prompt: String, isHD: Bool, isVivid: Bool, sticker: Sticker) -> Task<Void, Never> {
//    Task { @MainActor in
//      do {
//        let imageResponse = try await self.openAIClient.generateDallE3Image(
//          prompt: prompt,
//          quality: isHD ? .hd : .standard,
//          style: isVivid ? .vivid : .natural
//        )
//        
//        try Task.checkCancellation()
//        guard let urlString = imageResponse.url,
//              let url = URL(string: urlString)
//        else {
//          throw "Image response is null"
//        }
//        let (data, _) = try await URLSession.shared.data(from: url)
//        guard let image = CIImage(data: data) else {
//          throw "failed to download image"
//        }
//        let imageData = generateImageData(image)
//        try Task.checkCancellation()
//        self.updateSticker(sticker, shouldSwitchToUIThread: true) {
//          $0.state = .completed(imageData)
//          if self.trayIcon.imageData == nil {
//            self.updateSticker(self.trayIcon) {
//              $0.state = .completed(imageData)
//            }
//          }
//        }
//      } catch {
//        if error is CancellationError { return }
//        self.updateSticker(sticker, shouldSwitchToUIThread: true) {
//          $0.state = .failure(error)
//        }
//      }
//    }
//  }
//
//  private func generateDallE3Image(promptText: String, sticker: Sticker) {
//    let task = generateDallE3ImageTask(prompt: promptText, sticker: sticker)
//    self.updateSticker(sticker) {
//      $0.state = .generating(task)
//    }
//  }
//
//  private func onInputImageSelected(_ image: CIImage, sticker: Sticker) {
//    let task = Task {
//      do {
//        let imageData = generateImageData(image)
//        try Task.checkCancellation()
//        self.updateSticker(sticker) {
//          $0.state = .completed(imageData)
//        }
//      } catch let error {
//        if error is CancellationError { return }
//        self.updateSticker(sticker) {
//          $0.state = .failure(error)
//        }
//      }
//    }
//    self.updateSticker(sticker) { $0.state = .generating(task) }
//  }
//  
//  func generateImageData(_ image: CIImage) -> ImageData {
//    let inputCIImage = image
//    let inputImage = UIImage(cgImage: render(ciImage: inputCIImage))
//    let imageData = ImageData(inputCIImage: inputCIImage, inputImage: inputImage, outputImage: outputImage)
//    return imageData
//  }

}
