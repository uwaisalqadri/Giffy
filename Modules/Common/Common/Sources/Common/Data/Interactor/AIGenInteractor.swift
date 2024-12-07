//
//  AIGenInteractor.swift
//
//
//  Created by Uwais Alqadri on 06/12/24.
//

import Foundation
import Core
import SwiftOpenAI

public struct AIGenInteractor<
  GiphyDataSource: DataSource>: Repository
where
  GiphyDataSource.Response == [String],
  GiphyDataSource.Request == String {
  
  public typealias Request = String
  public typealias Response = [String]
  
  private let remoteDataSource: GiphyDataSource
  
  public init(remoteDataSource: GiphyDataSource) {
    self.remoteDataSource = remoteDataSource
  }
  
  public func execute(request: String?) async throws -> [String] {
    return try await remoteDataSource.execute(request: request)
  }
}

