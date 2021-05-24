//
//  HomeAssembler.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/05/21.
//

import SwiftUI

protocol HomeAssembler {
  func resolve() -> HomeView
  func resolve() -> HomeViewModel
  func resolve() -> HomeUseCase
  func resolve() -> HomeRepository
}

extension HomeAssembler {
  func resolve() -> HomeView {
    return HomeView(viewModel: resolve())
  }

  func resolve() -> HomeViewModel {
    return HomeViewModel(homeUseCase: resolve())
  }

  func resolve() -> HomeUseCase {
    return HomeInteractor(repository: resolve())
  }

  func resolve() -> HomeRepository {
    return DefaultHomeRepository(remoteDataSource: DefaultRemoteDataSource())
  }
}
