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
      GiphyRemoteDataSource  
    >
  >
>

struct HomeView: View {

  @ObservedObject var presenter: HomePresenter
  @State var giphys = [Giphy]()
  let router: FavoriteRouter

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
    NavigationView {
      ScrollView(.vertical, showsIndicators: false) {
        LazyVStack(alignment: .leading) {
          Text("today_popular".localized())
            .font(.system(size: 20, weight: .medium))
            .padding(.leading, 15)

          if !presenter.isLoading {
            HStack(alignment: .top) {
              LazyVStack(spacing: 8) {
                ForEach(Array(splittedGiphys[0].enumerated()), id: \.offset) { _, item in
                  HomeItemView(giphy: item, router: Injection.shared.resolve())
                    .padding(.horizontal, 5)
                }
              }

              LazyVStack(spacing: 8) {
                ForEach(Array(splittedGiphys[1].enumerated()), id: \.offset) { _, item in
                  HomeItemView(giphy: item, router: Injection.shared.resolve())
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
      }.navigationTitle("trending".localized())
      .navigationBarItems(
        trailing: NavigationLink(destination: router.routeFavorite()) {
          Image(systemName: "heart.fill")
            .resizable()
            .foregroundColor(.red)
            .frame(width: 20, height: 18)
        }
      )
    }.navigationViewStyle(StackNavigationViewStyle())
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
    HomeView(presenter: Injection.shared.resolve(), router: Injection.shared.resolve())
  }
}
