//
//  GiphyGIFTests.swift
//  GiphyGIFTests
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

// TODO: Write some unit test
class GiphyGIFTests: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testTrendingUseCase() throws {
    let useCase: DummyInteractor = DummyInjection().resolve()
    let response = useCase.execute(request: 0)
    let result = try response.waitForCompletion()

    XCTAssertEqual(result.count, 1)
    XCTAssertEqual(result.compactMap({ $0[0].title }), ["Funny GIF"])
  }

}
