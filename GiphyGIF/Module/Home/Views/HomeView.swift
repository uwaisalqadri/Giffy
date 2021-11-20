//
//  HomeView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import SwiftUI
import Grid
import Core
import Giphy

typealias HomePresenter = GetListPresenter<
  Int, Giphy, Interactor<
    Int, [Giphy], GetGiphyRepository<
      GiphyRemoteDataSource  
    >
  >
>

struct HomeView: View {

  @ObservedObject var presenter: HomePresenter
  let router: FavoriteRouter
  let style = StaggeredGridStyle(.vertical, tracks: .min(150), spacing: 5)
  let ipadStyle = StaggeredGridStyle(.vertical, tracks: .min(250), spacing: 5)
  let isIpad = UIDevice.current.userInterfaceIdiom == .pad

  var body: some View {
    NavigationView {
      ScrollView(.vertical, showsIndicators: false) {
        LazyVStack(alignment: .leading) {
          Text("today_popular".localized())
            .font(.system(size: 20, weight: .medium))
            .padding(.leading, 15)

          Grid(Array(presenter.list.enumerated()), id: \.offset) { index, item in
            HomeItemView(giphy: item, router: Injection.shared.resolve())
              .padding(.horizontal, 5)
          }
        }.padding(.bottom, 60)
        .padding(.horizontal, 10)
      }.navigationTitle("trending".localized())
      .gridStyle(isIpad ? ipadStyle : style)
      .navigationBarItems(
        trailing: NavigationLink(destination: router.makeFavoriteView()) {
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
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView(presenter: Injection.shared.resolve(), router: Injection.shared.resolve())
  }
}
