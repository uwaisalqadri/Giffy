//
//  HomeViewModel.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/05/21.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {

  private let homeUseCase: HomeUseCase

  private var cancellables: Set<AnyCancellable> = []
  @Published var giphys: [Giphy] = []
  @Published var errorMessage: String = ""
  @Published var loadingState: Bool = false

  init(homeUseCase: HomeUseCase) {
    self.homeUseCase = homeUseCase
  }

  func getTrendingGiphy() {
    self.loadingState = true
    homeUseCase.getTrendingGiphy()
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .failure:
          self.errorMessage = String(describing: completion)
        case .finished:
          self.loadingState = false
        }
      }, receiveValue: { result in
        print(result)
        self.giphys = result
      }).store(in: &cancellables)
  }

  func getRandomGiphy() {
    self.loadingState = true
    homeUseCase.getRandomGiphy()
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .failure:
          self.errorMessage = String(describing: completion)
        case .finished:
          self.loadingState = false
        }
      }, receiveValue: { result in
        self.giphys = result
      }).store(in: &cancellables)
  }
}
