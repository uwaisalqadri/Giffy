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
  
  @Router private var router
  private let favoriteUseCase: FavoriteUseCase
  private let removeUseCase: RemoveFavoriteUseCase

  init(favoriteUseCase: FavoriteUseCase, removeUseCase: RemoveFavoriteUseCase) {
    self.favoriteUseCase = favoriteUseCase
    self.removeUseCase = removeUseCase
  }
  
  @ObservableState
  public struct State: Equatable {
    public var list: [Giffy] = []
    public var errorMessage: String = ""
    public var isLoading: Bool = false
    public var shareImage: Data?
    public var isError: Bool = false
    public let detailDisappear = NotificationCenter.default.publisher(for: Notifications.onDetailDisappear)
    
    var share: StoreOf<ShareReducer> {
      Store(initialState: .init(shareImage)) {
        ShareReducer()
      }
    }
  }
  
  public enum Action {
    case fetch(request: String = "")
    case success(response: [Giffy])
    case failed(error: Error)
    
    case removeFavorite(item: Giffy, request: String)
    case showDetail(item: Giffy)
    case showShare(Data?)
    case didBackPressed
  }
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .fetch(request):
        state.isLoading = true
        return .run { send in
          do {
            let response = try await favoriteUseCase.execute(request: request)
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
        router.present(.detail(items: state.list.setHighlighted(item)))
        return .none
        
      case let .showShare(image):
        state.shareImage = image
        return .none
        
      case .didBackPressed:
        router.pop()
        return .none
      }
    }
  }
}
