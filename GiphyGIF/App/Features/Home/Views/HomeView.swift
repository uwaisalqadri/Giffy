//
//  HomeView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import SwiftUI

struct HomeView: View {

  @ObservedObject var viewModel: HomeViewModel

  var body: some View {
    if viewModel.loadingState {
      ActivityIndicator()
    } else {
      Text("Home View")
    }
  }
}

//struct HomeView_Previews: PreviewProvider {
//  static var previews: some View {
//    HomeView()
//  }
//}
