//
//  HomeView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import SwiftUI
import Grid
import Core

struct HomeView: View {

  @ObservedObject var viewModel: HomeViewModel
  let style = StaggeredGridStyle(.vertical, tracks: .min(150), spacing: 5)
  let assembler = AppAssembler()

  var body: some View {
    NavigationView {
      ScrollView {
        LazyVStack(alignment: .leading) {
          Text(viewModel.giphys.isEmpty
                ? "Pull to Get Latest"
                : "Today's Popular Giphy")
            .font(.system(size: 20, weight: .medium)).padding(.leading, 20)
          Grid(viewModel.giphys, id: \.id) { item in
            HomeItemView(giphy: item)
              .padding(.horizontal, 5)
          }.padding(.bottom, 60)
          .padding(.horizontal, 10)
        }
      }.navigationTitle("Trending")
      .gridStyle(self.style)
      .navigationBarItems(
        trailing: NavigationLink(destination: FavoriteView(viewModel: assembler.resolve())) {
          Image(systemName: "heart.fill")
            .resizable()
            .foregroundColor(.green)
            .frame(width: 20, height: 18)
        }
      )
    }.onAppear {
      viewModel.getTrendingGiphy()
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    let assembler = AppAssembler()
    HomeView(viewModel: assembler.resolve())
  }
}
