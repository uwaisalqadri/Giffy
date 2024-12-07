//
//  FavoriteReducer.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/9/23.
//

import Foundation
import ComposableArchitecture
import CommonUI
import Common

@Reducer
public struct FavoriteReducer {
  
  @Route var router
  private let useCase: FavoriteUseCase
  private let removeUseCase: RemoveFavoriteUseCase

  init(useCase: FavoriteUseCase, removeUseCase: RemoveFavoriteUseCase) {
    self.useCase = useCase
    self.removeUseCase = removeUseCase
  }
  
  @ObservableState
  public struct State: Equatable {
    public var list: [Giffy] = []
    public var errorMessage: String = ""
    public var isLoading: Bool = false
    public var isError: Bool = false
    public let detailDisappear = NotificationCenter.default.publisher(for: Notifications.onDetailDisappear)
  }
  
  public enum Action {
    case fetch(request: String = "")
    case success(response: [Giffy])
    case failed(error: Error)
    
    case removeFavorite(item: Giffy, request: String)
    case showDetail(item: Giffy)
    case didBackPressed
  }
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .fetch(request):
        state.isLoading = true
        return .run { send in
          do {
            let response = try await self.useCase.execute(request: request)
            await send(.success(response: response))
          } catch {
            await send(.failed(error: error))
          }
        }
        
      case let .success(data):
        state.list = data
        state.isLoading = false
        return .none
        
      case .failed:
        state.isError = true
        state.isLoading = false
        return .none
        
      case let .removeFavorite(item, request):
        return .run { send in
          do {
            _ = try await self.removeUseCase.execute(request: item)
            await send(.fetch(request: request))
          } catch {
            await send(.failed(error: error))
          }
        }
        
      case let .showDetail(item):
        router.present(.detail(item))
        return .none
        
      case .didBackPressed:
        router.pop()
        return .none
      }
    }
  }
}
