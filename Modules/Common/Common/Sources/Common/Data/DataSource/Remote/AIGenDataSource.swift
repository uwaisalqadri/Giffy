//
//  AIGenDataSource.swift
//
//
//  Created by Uwais Alqadri on 10/11/24.
//

import Core
import SwiftOpenAI

public struct AIGenDataSource: DataSource {
  public typealias Request = String
  public typealias Response = [String]

  private let openAI = SwiftOpenAI(apiKey: APIConfig.openAIConfig.apiKey)
  
  public init() {}
  
  public func execute(request: String?) async throws -> [String] {
    let image = try await openAI.createImages(
      model: .dalle(.dalle3),
      prompt: request ?? "",
      numberOfImages: 1,
      size: .s512
    )
    
    return image?.data.compactMap { $0.url } ?? []
  }
  
}
