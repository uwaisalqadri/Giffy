//
//  DetailViewModel.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 01/06/21.
//

import Foundation
import Core
import Combine

class DetailViewModel: ObservableObject {

  private let detailUseCase: DetailUseCase

  private var cancellables: Set<AnyCancellable> = []
  @Published var giphys: [Giphy] = []
  @Published var errorMessage: String = ""
  @Published var loadingState: Bool = false
  @Published var isFavorite: Bool = true

  init(detailUseCase: DetailUseCase) {
    self.detailUseCase = detailUseCase
  }

  func checkFavorites(idGiphy: String) {
    detailUseCase.getFavoriteGiphys()
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .failure:
          self.errorMessage = String(describing: completion)
        case .finished:
          print("finished")
        }
      }, receiveValue: { result in
        result.forEach { item in
          self.isFavorite = item.id.contains(idGiphy)
        }
      })
      .store(in: &cancellables)
  }

  func addToFavorites(giphy: Giphy) {
    detailUseCase.addToFavoriteGiphys(from: giphy)
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .failure:
          self.errorMessage = String(describing: completion)
        case .finished:
          print("finish saving")
        }
      }, receiveValue: { result in
        print("saved \(result)")
      })
      .store(in: &cancellables)
  }
  
  func removeFromFavorites(idGiphy: String) {
    detailUseCase.removeFavoriteGiphy(from: idGiphy)
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .failure:
          self.errorMessage = String(describing: completion)
        case .finished:
          print("finish remove")
        }
      }, receiveValue: { result in
        print("removed \(result)")
      })
      .store(in: &cancellables)
  }
}
