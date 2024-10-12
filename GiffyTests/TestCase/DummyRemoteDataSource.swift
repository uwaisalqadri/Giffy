//
//  DummyRemoteDataSource.swift
//  GiphyGIFTests
//
//  Created by Uwais Alqadri on 8/9/22.
//

@testable import Giffy
@testable import Common
@testable import Core
import Combine
import Foundation

struct DummyRemoteDataSource: DataSource {
  typealias Request = Int
  typealias Response = [Giffy]

  func execute(request: Int?) async throws -> [Giffy] {
    if request == 10 {
      return try await createErrorResponse()
    }

    let result = try await createDummyArrayResponse()

    return result
  }

  private func createDummyArrayResponse() async throws -> [Giffy] {
    return try await JSONLoader<GiphyDataResponse>().load(fileName: "GiphyMockResponse").data.map { $0.map() }
  }

  private func createErrorResponse() async throws -> [Giffy] {
    return try await withCheckedThrowingContinuation { promise in
      promise.resume(throwing: ApiError.networkFailure(error: NetworkError.internalServerError))
    }
  }
}
