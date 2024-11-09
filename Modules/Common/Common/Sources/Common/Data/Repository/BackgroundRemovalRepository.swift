//
//  BackgroundRemovalRepository.swift
//
//
//  Created by Uwais Alqadri on 10/11/24.
//

import Foundation
import Core
import UIKit

public struct BackgroundRemovalRepository<
  GiphyDataSource: DataSource>: Repository
where
  GiphyDataSource.Response == ImageData,
  GiphyDataSource.Request == CIImage {
  
  public typealias Request = CIImage
  public typealias Response = ImageData
  
  private let remoteDataSource: GiphyDataSource
  
  public init(remoteDataSource: GiphyDataSource) {
    self.remoteDataSource = remoteDataSource
  }
  
  public func execute(request: CIImage?) async throws -> ImageData {
    return try await remoteDataSource.execute(request: request)
  }
}
