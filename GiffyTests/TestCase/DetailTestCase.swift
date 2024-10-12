//
//  DetailTestCase.swift
//  GiphyGIFTests
//
//  Created by Uwais Alqadri on 28/10/23.
//

@testable import Giffy
@testable import Common
@testable import Core
import Combine
import XCTest
import ComposableArchitecture

@MainActor
final class DetailTestCase: XCTestCase {
  
  private var store: TestStore<DetailReducer.State, DetailReducer.Action>!
  private let itemToAdd: Giffy = .init(title: "Yuhu")
  
  override func setUp() {
    super.setUp()

    store = TestStore(
      initialState: DetailReducer.State(item: itemToAdd)
    ) {
      let detailReducer: DetailReducer = TestInjection().resolve()
      detailReducer
    }
  }
  
  override func tearDown() {
    super.tearDown()
    store = nil
  }
  
  func testDetailAddFavorite() async {
    await store.send(.addFavorite(item: itemToAdd))
    await store.receive(.success(isFavorited: true)) {
      $0.isFavorited = true
    }
  }
  
  func testDetailRemoveFavorite() async {
    await store.send(.removeFavorite(item: itemToAdd))
    await store.receive(.success(isFavorited: false))
  }
  
  func testDetailDowloadShareableGIF() async {
    await store.send(.downloadedGIF(sharedData: []))
  }
}

extension DetailReducer.Action: Equatable {
  public static func == (lhs: DetailReducer.Action, rhs: DetailReducer.Action) -> Bool {
    lhs.id == rhs.id
  }

  public var id: String {
    String(describing: self)
  }
}
