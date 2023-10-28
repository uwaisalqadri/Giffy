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

class GiphyLocalDataSourceTestCase: XCTestCase {
  
  func testInsertFavoriteUseCase() async throws {
    let dummyUseCase: DummyGetGiphyInteractor = TestInjection().resolve()
    let useCase: AddFavoriteInteractor = TestInjection().resolve()
    
    let item = try await dummyUseCase.execute(request: 0).first
    let favoritedItem = try await useCase.execute(request: item)
    XCTAssertEqual(favoritedItem.title, "Happy Anniversary Love GIF by Hallmark Gold Crown")
  }
  
  func testActualGetFavoriteUseCase() async throws {
    let useCase: FavoriteInteractor = TestInjection().resolve()
    let result = try await useCase.execute(request: "")
    XCTAssertFalse(result.isEmpty, "Favorite Exist")
  }
  
}
