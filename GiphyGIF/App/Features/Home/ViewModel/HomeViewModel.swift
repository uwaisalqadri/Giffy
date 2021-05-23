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

  init(homeUseCase: HomeUseCase) {
    self.homeUseCase = homeUseCase
  }
}
