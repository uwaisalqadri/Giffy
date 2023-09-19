//
//  HomeView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import SwiftUI
import Core
import Giphy
import Common

typealias HomePresenter = GetListPresenter<
  Int, Giphy, Interactor<
    Int, [Giphy], GetGiphyRepository<
      TrendingRemoteDataSource
    >
  >
>

struct HomeView: ViewControllable {
  var holder: Common.NavStackHolder
  
  @ObservedObject var presenter: HomePresenter
  @State private var giphys = [Giphy]()
  let router: HomeRouter

  private var splittedGiphys: [[Giphy]] {
    var result: [[Giphy]] = []

    var firstGiphys: [Giphy] = []
    var secondGiphys: [Giphy] = []

    giphys.forEach { giphy in
      let index = giphys.firstIndex {$0.identifier == giphy.identifier }

      if let index = index {
        if index % 2 == 0 {
          firstGiphys.append(giphy)
        } else {
          secondGiphys.append(giphy)
        }
      }
    }

    result.append(firstGiphys)
    result.append(secondGiphys)

    return result
  }

  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      LazyVStack(alignment: .leading) {
        Text(HomeString.labelTodayPopular.localized)
          .font(.system(size: 20, weight: .medium))
          .padding(.leading, 15)

        if !presenter.isLoading {
          HStack(alignment: .top) {
            LazyVStack(spacing: 8) {
              ForEach(Array(splittedGiphys[0].enumerated()), id: \.offset) { _, item in
                HomeRow(giphy: item) { selectedItem in
                  guard let viewController = holder.viewController else { return }
                  router.routeToDetail(from: viewController, giphy: selectedItem)
                }
                .padding(.horizontal, 5)
              }
            }

            LazyVStack(spacing: 8) {
              ForEach(Array(splittedGiphys[1].enumerated()), id: \.offset) { _, item in
                HomeRow(giphy: item) { selectedItem in
                  guard let viewController = holder.viewController else { return }
                  router.routeToDetail(from: viewController, giphy: selectedItem)
                }
                .padding(.horizontal, 5)
              }
            }
          }

        } else {
          HStack {
            Spacer()
            ActivityIndicator()
              .padding(.top, 60)
            Spacer()
          }
        }

      }.padding(.bottom, 60)
        .padding(.horizontal, 10)
    }
    .navigationTitle(HomeString.titleTrending.localized)
    .navigationViewStyle(.stack)
    .navigationBarItems(
      trailing: Button(action: {
        guard let viewController = holder.viewController else { return }
        router.routeToFavorite(from: viewController)
      }) {
        Image(systemName: "heart.fill")
          .resizable()
          .foregroundColor(.red)
          .frame(width: 20, height: 18)
      }
    )
    .onAppear {
      presenter.getList(request: 0)
    }
    .onReceive(presenter.$list) { list in
      giphys = list
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView(holder: Injection.shared.resolve(), presenter: Injection.shared.resolve(), router: Injection.shared.resolve())
  }
}
