//
//  SearchView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 24/05/21.
//

import SwiftUI

struct SearchView: View {

  let viewModel: SearchViewModel

  init(viewModel: SearchViewModel) {
    self.viewModel = viewModel
  }

  var body: some View {
    Text("Search View")
      .onAppear {
        viewModel.getSearchGiphy(query: "Swift iOS")
      }
  }
}

//struct SearchView_Previews: PreviewProvider {
//  static var previews: some View {
//    SearchView()
//  }
//}
