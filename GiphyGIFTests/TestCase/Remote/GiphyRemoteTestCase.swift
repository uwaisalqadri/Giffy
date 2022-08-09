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

typealias DummyInteractor = Interactor<
  Int, [Giphy], GetGiphyRepository<
    DummyRemoteDataSource
  >
>

typealias ActualTrendingInteractor = Interactor<
  Int, [Giphy], GetGiphyRepository<
    GiphyRemoteDataSource
  >
>

typealias ActualSearchInteractor = Interactor<
  String, [Giphy], SearchGiphyRepository<
    SearchRemoteDataSource
  >
>

class GiphyRemoteTestCase: XCTestCase {

  override func setUp() {
    super.setUp()
  }

  override func tearDown() {
    super.tearDown()
  }

  func testMockGetTrendingUseCase() throws {
    // given
    let useCase: DummyInteractor = TestInjection().resolve()

    // when
    let response = useCase.execute(request: 0)

    // then
    let result = try response.waitForCompletion()
    XCTAssertEqual(result.compactMap({ $0[0].title }), ["Happy Anniversary Love GIF by Hallmark Gold Crown"])
  }

  func testActualGetTrendingUseCase() throws {
    // given
    let useCase: ActualTrendingInteractor = TestInjection().resolve()

    // when
    let response = useCase.execute(request: 0) // and

    // then
    let result = try response.waitForCompletion()
    XCTAssertFalse(result.isEmpty, "Data Fetched from network")
  }

  // TODO: testActualGetRandomUseCase() Need Refactor
  func testActualGetRandomUseCase() throws {
    // given
    let useCase: ActualTrendingInteractor = TestInjection().resolve()

    // when
    let response = useCase.execute(request: 1) // and

    // then
    let result = try response.waitForCompletion()
    XCTAssertFalse(result.isEmpty, "Data Fetched from network")
  }

  func testActualGetSearchUseCase() throws {
    // given
    let useCase: ActualSearchInteractor = TestInjection().resolve()

    // when
    let response = useCase.execute(request: "Hello") // and

    // then
    let result = try response.waitForCompletion()
    XCTAssertTrue(result[0][0].title.contains("Hello"))
  }
}
