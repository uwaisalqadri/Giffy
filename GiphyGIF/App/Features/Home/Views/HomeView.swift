//
//  HomeView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import SwiftUI
import Grid

struct HomeView: View {

  @ObservedObject var viewModel: HomeViewModel
  @State var showPlayer = false
  let style = StaggeredGridStyle(.vertical, tracks: .min(150), spacing: 5)

  var body: some View {
    NavigationView {
      ScrollView {
        VStack(alignment: .leading) {
          Text("Today's Popular Giphy").font(.system(size: 20, weight: .medium)).padding(.leading, 20)
          Grid(viewModel.giphys, id: \.id) { item in
            HomeItemView(giphy: item)
              .padding(.horizontal, 5)
              .sheet(isPresented: $showPlayer) {
                DetailView(giphy: item)
              }
              .onTapGesture {
                showPlayer = true
              }
          }.padding(.bottom, 60)
          .padding(.horizontal, 10)
        }
      }.navigationTitle("Trending")
      .gridStyle(self.style)
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
