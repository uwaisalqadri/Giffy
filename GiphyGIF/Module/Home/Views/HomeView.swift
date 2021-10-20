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
  let style = StaggeredGridStyle(.vertical, tracks: .min(150), spacing: 5)

  var body: some View {
    NavigationView {
      ScrollView(.vertical, showsIndicators: false) {
        LazyVStack(alignment: .leading) {
          Text(presenter.list.isEmpty
                ? "Pull to Get Latest"
                : "Today's Popular Giphy")
            .font(.system(size: 20, weight: .medium)).padding(.leading, 20)
          Grid(Array(presenter.list.enumerated()), id: \.offset) { index, item in
            HomeItemView(giphy: item)
              .padding(.horizontal, 5)
          }
        }.padding(.bottom, 60)
        .padding(.horizontal, 10)
      }.navigationTitle("Trending")
      .gridStyle(self.style)
      .navigationBarItems(
        trailing: NavigationLink(destination: FavoriteView(presenter: Injection.shared.resolve())) {
          Image(systemName: "heart.fill")
            .resizable()
            .foregroundColor(.red)
            .frame(width: 20, height: 18)
        }
      )
    }.onAppear {
      presenter.getList(request: 0)
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView(presenter: Injection.shared.resolve())
  }
}
