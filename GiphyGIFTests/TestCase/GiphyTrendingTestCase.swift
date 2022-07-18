//
//  GiphyTrendingTestCase.swift
//  GiphyTrendingTestCase
//
//  Created by Uwais Alqadri on 06/06/21.
//

@testable import GiphyGIF
@testable import Giphy
@testable import Core
import Combine
import XCTest

typealias DummyTrendingInteractor = Interactor<
  Int, [Giphy], GetGiphyRepository<
    DummyTrendingRemoteDataSource
  >
>

class GiphyTrendingTestCase: XCTestCase {
  var useCase: DummyTrendingInteractor!

  override func setUp() {
    super.setUp()
    useCase = TestInjection().resolve()
  }

  override func tearDown() {
    useCase = nil
    super.tearDown()
  }

  func testMockGetTrendingUseCase() throws {
    let response = useCase.execute(request: 0)
    let result = try response.waitForCompletion()

    XCTAssertEqual(result.compactMap({ $0[0].title }), ["Happy Anniversary Love GIF by Hallmark Gold Crown"])
  }

  func testDumbestForDummies() {
    let result = 0

    XCTAssertEqual(result, 0, "is equal you fuck!")
  }
}

struct DummyTrendingRemoteDataSource: DataSource {
  typealias Request = Int
  typealias Response = [Giphy]

  func execute(request: Int?) -> AnyPublisher<[Giphy], Error> {
    if request == 10 {
      return createErrorResponse()
    }

    let result = createDummyArrayResponse()
      .compactMap { $0.data }
      .eraseToAnyPublisher()

    return result
  }

  private func createDummyArrayResponse() -> AnyPublisher<GiphyResponse, Error> {
    return JSONLoader<GiphyResponse>().load(fileName: "GiphyMockResponse")
  }

  private func createErrorResponse() -> AnyPublisher<[Giphy], Error> {
    return Future<[Giphy], Error> { completion in
      completion(.failure(ApiError.networkFailure(error: NetworkError.internalServerError)))
    }
    .eraseToAnyPublisher()
  }
}
