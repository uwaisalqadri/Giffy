//
//  GiphyLocalTestCase.swift
//  GiphyGIFTests
//
//  Created by Uwais Alqadri on 8/10/22.
//

@testable import GiphyGIF
@testable import Giphy
@testable import Core
import Combine
import XCTest

typealias AddFavoriteInteractor = Interactor<
  Giphy, Giphy, AddFavoriteRepository<
    GiphyLocalDataSource
  >
>

typealias FavoriteInteractor = Interactor<
  String, [Giphy], FavoriteGiphysRepository<
    GiphyLocalDataSource
  >
>

class GiphyLocalTestCase: XCTestCase {

  func testInsertFavoriteUseCase() throws {
    // given
    let dummyUseCase: DummyInteractor = TestInjection().resolve()
    let useCase: AddFavoriteInteractor = TestInjection().resolve()

    // when
    let dummyResponse = dummyUseCase.execute(request: 0)
    let dummyResult = try dummyResponse.waitForCompletion()
    let response = useCase.execute(request: dummyResult.first?.first)
    let result = try response.waitForCompletion()

    // then
    XCTAssertEqual(result.first?.isFavorite, true, "Favorited")
  }

  func testActualGetFavoriteUseCase() throws {
    // given
    let useCase: FavoriteInteractor = TestInjection().resolve()

    // when
    let response = useCase.execute(request: "")
    let result = try response.waitForCompletion()

    // then
    XCTAssertFalse(result.isEmpty, "Favorite Exist")
  }

}
