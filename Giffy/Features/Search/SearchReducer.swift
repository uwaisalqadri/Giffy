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
import SDWebImage

@Reducer
public struct SearchReducer {
  
  @Route var router
  private let searchUseCase: SearchUseCase

  init(searchUseCase: SearchUseCase) {
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
    
    public var allItems: [Giffy] {
      var combinedItems: [Giffy] = []
      let leftItems = items(.left)
      let rightItems = items(.right)
      let maxCount = max(rightItems.count, leftItems.count)
      
      for index in 0..<maxCount {
        if index < rightItems.count {
          combinedItems.append(rightItems[index]) // Add from right (odd indices)
        }
        if index < leftItems.count {
          combinedItems.append(leftItems[index]) // Add from left (even indices)
        }
      }
      
      return combinedItems
    }
    
    public func currentPosition(_ giffy: Giffy) -> Int {
      allItems.firstIndex(where: { $0.id == giffy.id }) ?? 0
    }
    
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
    case initialFetch
    case fetch(request: String)
    case success(response: [Giffy])
    case failed(error: Error)
    
    case showDetail(item: Giffy)
    case openFavorite
  }
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .initialFetch:
        return .run { send in
          await send(.fetch(request: greetingText))
        }
        
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
          SDWebImagePrefetcher.shared.prefetchURLs(data.compactMap { URL(string: $0.url) } )
        }
        return .none
        
      case .failed:
        state.isEmpty = true
        state.isLoading = false
        return .none
        
      case let .showDetail(item):
        var allItems = state.allItems
        allItems[state.currentPosition(item)].isHighlighted = true
        router.present(.detail(items: allItems))
        return .none

      case .openFavorite:
        router.push(.favorite)
        return .none
      }
    }
  }
  
  public var greetingText: String {
      let hour = Calendar.current.component(.hour, from: Date())
      switch hour {
      case 5..<12:
          return "Good Morning"
      case 12..<17:
          return "Good Afternoon"
      case 17..<21:
          return "Good Evening"
      default:
          return "Good Night"
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
