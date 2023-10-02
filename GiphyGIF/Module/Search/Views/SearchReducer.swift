//
//  SearchReducer.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/9/23.
//

import Foundation
import ComposableArchitecture
import Core
import Giphy
import Common

typealias SearchInteractor = Interactor<
  String, [Giphy], SearchGiphyRepository<
    SearchRemoteDataSource
  >
>

public struct SearchReducer: Reducer {
  
  private let useCase: SearchInteractor
  
  init(useCase: SearchInteractor) {
    self.useCase = useCase
  }
  
  public struct State: Equatable {
    public var list: [Giphy] = []
    public var errorMessage: String = ""
    public var isLoading: Bool = false
    public var isError: Bool = false
  }
  
  public enum Action {
    case fetch(request: String)
    case success(response: [Giphy])
    case failed(error: Error)
    
    case showDetail(item: Giphy)
    case openFavorite
  }
  
  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { state, action in
      switch action {
      case .fetch(let request):
        state.isLoading = true
        return .run { send in
          do {
            let response = try await self.useCase.execute(request: request)
            await send(.success(response: response))
          } catch {
            await send(.failed(error: error))
          }
        }
        
      case .success(let data):
        state.list = data
        state.isLoading = false
        return .none
        
      case .failed:
        state.isError = true
        state.isLoading = false
        return .none
        
      case .showDetail, .openFavorite:
        return .none
      }
    }
  }
}
