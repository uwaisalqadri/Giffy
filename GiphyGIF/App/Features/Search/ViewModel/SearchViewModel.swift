//
//  SearchViewModel.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/05/21.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {

  let searchUseCase: SearchUseCase

  private var cancellables: Set<AnyCancellable> = []
  @Published var giphys: [Giphy] = []
  @Published var errorMessage: String = ""
  @Published var loadingState: Bool = false

  init(searchUseCase: SearchUseCase) {
    self.searchUseCase = searchUseCase
  }

  func getSearchGiphy(query: String) {
    self.loadingState = true
    searchUseCase.getSearchGiphy(query: query)
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
}
