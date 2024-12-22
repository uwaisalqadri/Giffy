//
//  ShareReducer.swift
//  Giffy
//
//  Created by Uwais Alqadri on 22/12/24.
//

import Foundation
import ComposableArchitecture
import Common
import CommonUI

@Reducer
public struct ShareReducer {
  
  @Route var router
  
  init() {
  }
  
  @ObservableState
  public struct State: Equatable {
    var images: [Data] = []
  }
  
  public enum Action {
    case onShare
  }
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .onShare:
        return .none
      }
    }
  }
}
