//
//  DetailView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import SwiftUI
import Giphy
import Core
import Common
import ComposableArchitecture

struct DetailView: ViewControllable {
  var holder: Common.NavStackHolder
  var store: StoreOf<DetailReducer>
  
  let giphy: Giphy
  
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      NavigationView {
        WebView(url: URL(string: giphy.url))
          .edgesIgnoringSafeArea([.bottom, .horizontal])
          .navigationBarItems(
            leading: Button(action: {
              guard let viewController = holder.viewController else { return }
              viewController.navigationController?.popViewController(animated: true)
            }) {
              Image("heart")
                .resizable()
                .frame(width: 23, height: 20)
                .foregroundColor(.white)
            },
            trailing: Button(action: {
              if viewStore.state.isFavorited {
                viewStore.send(.removeFavorite(item: giphy))
              } else {
                viewStore.send(.addFavorite(item: giphy))
              }
            }) {
              Image(viewStore.state.isFavorited ? "heart.fill" : "heart", bundle: Bundle.common)
                .resizable()
                .frame(width: 23, height: 20)
                .foregroundColor(.red)
            }
          )
          .navigationTitle(DetailString.titleDetail.localized)
          .navigationBarTitleDisplayMode(.inline)
          .onAppear {
            viewStore.send(.checkFavorite(request: giphy.id))
          }
      }
    }
  }
}
