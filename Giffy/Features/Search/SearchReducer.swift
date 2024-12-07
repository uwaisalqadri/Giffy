//
//  SearchReducer.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 23/9/23.
//

import Foundation
import ComposableArchitecture
import Common
import CommonUI

@Reducer
public struct SearchReducer {
  
  @Route var router
  private let searchUseCase: SearchInteractor

  init(searchUseCase: SearchInteractor) {
    self.searchUseCase = searchUseCase
  }
  
  @ObservableState
  public struct State: Equatable {
    public var rightColumn: [Giffy] = []
    public var leftColumn: [Giffy] = []
    public var searchText: String = ""
    public var errorMessage: String = ""
    public var isLoading: Bool = false
    public var isEmpty: Bool = false
    
    public func items(_ side: SearchReducer.GridSide) -> [Giffy] {
      switch side {
      case .right:
        return rightColumn
      case .left:
        return leftColumn
      }
    }
  }
  
  public enum Action {
    case fetch(request: String)
    case success(response: [Giffy])
    case failed(error: Error)
    
    case showDetail(item: Giffy)
    case openFavorite
  }
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .fetch(let query):
        state.searchText = query
        state.isLoading = true
        return .run { send in
          do {
            let response = try await searchUseCase.execute(request: query)
            await send(.success(response: response))
          } catch {
            await send(.failed(error: error))
          }
        }
        
      case .success(let data):
        state.isEmpty = data.isEmpty
        state.isLoading = false

        if !data.isEmpty {
          state.rightColumn = GridSide.split(data, side: .right)
          state.leftColumn = GridSide.split(data, side: .left)
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
  
  public enum GridSide: CaseIterable {
    case right, left
    
    static func split(_ items: [Giffy], side: GridSide) -> [Giffy] {
      let allItems = items.enumerated()
      switch side {
      case .right:
        return allItems.compactMap { index, item in
          index % 2 == 0 ? item : nil
        }
      case .left:
        return allItems.compactMap { index, item in
          index % 2 != 0 ? item : nil
        }
      }
    }
  }
}
