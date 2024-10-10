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

@Reducer
public struct SearchReducer {
  
  @Route var router
  private let useCase: SearchInteractor

  init(useCase: SearchInteractor) {
    self.useCase = useCase
  }
  
  @ObservableState
  public struct State: Equatable {
    public var grid = SearchGrid.init()
    public var errorMessage: String = ""
    public var isLoading: Bool = false
    public var isEmpty: Bool = false
  }
  
  public enum Action {
    case fetch(request: String)
    case success(response: [Giphy])
    case failed(error: Error)
    
    case showDetail(item: Giphy)
    case openFavorite
  }
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
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
        state.isEmpty = data.isEmpty
        state.isLoading = false

        if !data.isEmpty {
          state.grid = splitGiphys(items: data)
        }
        return .none
        
      case .failed:
        state.isEmpty = true
        state.isLoading = false
        return .none
        
      case let .showDetail(item):
        router.present(.detail(item))
        return .none

      case .openFavorite:
        router.push(.favorite)
        return .none
      }
    }
  }
  
  public struct SearchGrid: Equatable {
    public var rightGrid = [Giphy]()
    public var leftGrid = [Giphy]()
  }
  
  private func splitGiphys(items: [Giphy]) -> SearchGrid {
    var firstGiphys: [Giphy] = []
    var secondGiphys: [Giphy] = []
    
    items.forEach { giphy in
      let index = items.firstIndex {$0.id == giphy.id }
      
      if let index = index {
        if index % 2 == 0 {
          firstGiphys.append(giphy)
        } else {
          secondGiphys.append(giphy)
        }
      }
    }
    
    return SearchGrid(rightGrid: firstGiphys, leftGrid: secondGiphys)
  }
}
