//
//  HomeReducer.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/9/23.
//

import Foundation
import ComposableArchitecture
import Common
import CommonUI
import SDWebImage

@Reducer
public struct HomeReducer {

  @Router private var router
  private let trendingUseCase: TrendingUseCase

  init(trendingUseCase: TrendingUseCase) {
    self.trendingUseCase = trendingUseCase
  }
  
  public struct State: Equatable {
    var list: [Giffy] = []
    var errorMessage: String = ""
    var isLoading: Bool = false
    var isError: Bool = false
    var isSharing: Bool = false
    var shareImage: Data?
    
    var share: StoreOf<ShareReducer> {
      Store(initialState: .init(shareImage)) {
        ShareReducer()
      }
    }
  }
  
  public enum Action {
    case fetch(request: Int)
    case success(response: [Giffy])
    case failed(error: Error)
    case showDetail(item: Giffy)
    case openFavorite
    case showShare(Data?)
  }
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .fetch(let request):
        state.isLoading = true
        return .run { send in
          do {
            let response = try await trendingUseCase.execute(request: request)
            let newResponse = try await response.asyncMap { item -> Giffy in
              var newItem = item
              if let url = URL(string: item.image.url) {
                newItem.image.data = try await CacheImage.downloadImage(from: url)
              }
              return newItem
            }
            await send(.success(response: newResponse))
          } catch {
            await send(.failed(error: error))
          }
        }
      case .success(let data):
        state.list = data
        state.isLoading = state.list.contains { $0.image.data == nil }
        return .none
        
      case .failed:
        state.isError = true
        state.isLoading = false
        return .none
        
      case let .showDetail(item):
        router.present(.detail(items: state.list.setHighlighted(item)))
        return .none

      case .openFavorite:
        router.push(.favorite)
        return .none
        
      case let .showShare(image):
        state.shareImage = image
        return .none
      }
    }
  }
}
