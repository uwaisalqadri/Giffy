//
//  AnyPublisher+Wait.swift
//  GiphyGIFTests
//
//  Created by Uwais Alqadri on 11/3/21.
//

import Combine
import XCTest

extension AnyPublisher {
    func waitForCompletion(timeout: TimeInterval = 1.0, file: StaticString = #file, line: UInt = #line) throws -> [Output] {
        let expectation = XCTestExpectation(description: "wait for completion")
        var completion: Subscribers.Completion<Failure>?
        var output = [Output]()

        let subscription = self.collect()
            .sink(receiveCompletion: { receiveCompletion in
                completion = receiveCompletion
                expectation.fulfill()
            }, receiveValue: { value in
                output = value
            })

        XCTWaiter().wait(for: [expectation], timeout: timeout)
        subscription.cancel()

        switch try XCTUnwrap(completion, "Publisher never completed", file: file, line: line) {
        case let .failure(error):
            throw error
        case .finished:
            return output
        }
    }
}
