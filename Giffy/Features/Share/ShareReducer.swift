//
//  ShareReducer.swift
//  Giffy
//
//  Created by Uwais Alqadri on 22/12/24.
//

import ComposableArchitecture
import Common
import CommonUI
import Foundation
import SwiftUI

@Reducer
public struct ShareReducer {
  
  @Route var router
  
  @ObservableState
  public struct State: Equatable {
    var topItems: [ShareType] = [.whatsapp, .instagram, .twitter, .telegram]
    var bottomItems: [ShareType] = [.copy, .more]
    
    var image: Data?
    init(_ image: Data?) {
      self.image = image
    }
  }
  
  public enum Action {
    case onShare(ShareType)
  }
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case let .onShare(type):
        switch type {
        case .whatsapp:
          break
        case .instagram:
          break
        case .twitter:
          break
        case .telegram:
          break
        case .copy:
          Toaster.success(message: Localizable.labelCopied.tr()).show()
        case .more:
          break
        }
        return .none
      }
    }
  }
}

public extension ShareReducer {
  enum ShareType {
    case whatsapp
    case instagram
    case twitter
    case telegram
    case copy
    case more
    
    var id: String {
      UUID().uuidString
    }
    
    var imageName: String {
      switch self {
      case .whatsapp:
        return "whatsapp"
      case .instagram:
        return "instagram"
      case .twitter:
        return "twitter"
      case .telegram:
        return "telegram"
      case .copy:
        return "copy"
      case .more:
        return "more"
      }
    }
  }
}
