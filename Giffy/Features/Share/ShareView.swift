//
//  ShareView.swift
//  Giffy
//
//  Created by Uwais Alqadri on 22/12/24.
//

import SwiftUI
import Core
import Common
import CommonUI
import ComposableArchitecture

struct ShareView: View {
  @Environment(\.dismissDialog) var dismissDialog
  let store: StoreOf<ShareReducer>
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(alignment: .center, spacing: 0) {
        Color(.darkGray)
          .clipShape(.capsule)
          .frame(width: 34, height: 4)
          .padding(.top, 8)
        
        Text(key: .labelShareVia)
          .font(.bold, size: 14)
          .padding(.top, 13)
        
        HStack(spacing: 16) {
          ForEach(viewStore.topItems, id: \.id) { item in
            Button(action: {
              viewStore.send(.onShare(item))
            }) {
              Image(item.rawValue, bundle: Bundle.common)
                .resizable()
                .frame(width: 50, height: 50)
            }
          }
        }
        .padding(.top, 20)
        
        HStack(spacing: 16) {
          ForEach(viewStore.bottomItems, id: \.id) { item in
            Button(action: {
              if case .copy = item {
                dismissDialog()
              }
              viewStore.send(.onShare(item))
            }) {
              Image(item.rawValue, bundle: Bundle.common)
                .resizable()
                .frame(width: 50, height: 50)
            }
          }
        }
        .padding(.top, 16)
        .padding(.bottom, 30)

      }
      .sheet(
        isPresented: viewStore.binding(
          get: { $0.showShareSheet },
          send: { _ in
            dismissDialog()
            return .dismissShare
          }
        )
      ) {
        ShareSheetView(
          activityItems: [viewStore.shareImageURL!],
          excludedActivityTypes: viewStore.excludedShareApps
        )
      }
    }
  }
}
