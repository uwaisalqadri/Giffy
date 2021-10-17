//
//  FavoriteViewModel.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 26/05/21.
//

import Foundation
import Combine

class FavoriteViewModel: ObservableObject {

//  private let favoriteUseCase: FavoriteUseCase
//
//  private var cancellables: Set<AnyCancellable> = []
//  @Published var giphys: [Giphy] = []
//  @Published var errorMessage: String = ""
//
//  init(favoriteUseCase: FavoriteUseCase) {
//    self.favoriteUseCase = favoriteUseCase
//  }
//
//  func getFavorites() {
//    favoriteUseCase.getFavoriteGiphys()
//      .receive(on: RunLoop.main)
//      .sink(receiveCompletion: { completion in
//        switch completion {
//        case .failure:
//          self.errorMessage = String(describing: completion)
//        case .finished:
//          print("finished")
//        }
//      }, receiveValue: { result in
//        self.giphys = result
//      })
//      .store(in: &cancellables)
//  }
//
//  func removeFromFavorites(idGiphy: String) {
//    favoriteUseCase.removeFavoriteGiphy(from: idGiphy)
//      .receive(on: RunLoop.main)
//      .sink(receiveCompletion: { completion in
//        switch completion {
//        case .failure:
//          self.errorMessage = String(describing: completion)
//        case .finished:
//          print("finish remove")
//        }
//      }, receiveValue: { result in
//        print("removed \(result)")
//      })
//      .store(in: &cancellables)
//  }
}
