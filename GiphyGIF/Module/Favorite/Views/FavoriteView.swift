//
//  FavoriteView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 26/05/21.
//

import SwiftUI
import Grid
import Lottie
import Core
import Giphy

typealias FavoritePresenter = GetListPresenter<
  String, Giphy, Interactor<
    String, [Giphy], FavoriteGiphysRepository<
      GiphyLocalDataSource
    >
  >
>

struct FavoriteView: View {

  @ObservedObject var presenter: FavoritePresenter
  let style = StaggeredGridStyle(.vertical, tracks: .min(150), spacing: 5)

  var body: some View {
    ScrollView {
      SearchInput { query in
        presenter.getList(request: query)
      }.padding(.top, 30)
      LazyVStack {
        if !presenter.list.isEmpty {
          Grid(Array(presenter.list.enumerated()), id: \.offset) { index, item in
            HomeItemView(giphy: item, router: Injection.shared.resolve())
              .padding(.horizontal, 5)
          }.padding(.bottom, 60)
          .padding(.top, 20)
          .padding(.horizontal, 10)
        } else {
          isFavoriteEmpty.padding(.top, 50)
        }
      }
    }.navigationTitle("favorite".localized())
    .gridStyle(self.style)
    .onAppear {
      presenter.getList(request: "")
    }
  }

  var isFavoriteEmpty: some View {
    VStack {
      LottieView(fileName: "favorite-empty", loopMode: .loop)
        .frame(width: 220, height: 220)
    }
  }
}

struct FavoriteView_Previews: PreviewProvider {
  static var previews: some View {
    FavoriteView(presenter: Injection.shared.resolve())
  }
}