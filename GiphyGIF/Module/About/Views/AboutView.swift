//
//  AboutView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 29/05/21.
//

import SwiftUI
import Common

struct AboutView: View {
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(alignment: .leading) {
          HStack {
            Image(uiImage: Common.loadImage(named: "tampandanberani"))
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: 80, height: 80)
              .cornerRadius(20)

            VStack(alignment: .leading) {
              Text("Uwais Alqadri")
                .font(.system(size: 24))
                .bold()

              SocialMediaItemView(image: "apple", name: "iOS Developer")
            }
            .padding(.leading)

            Spacer()
          }
          .padding(24)

          VStack(alignment: .leading) {
            SocialMediaItemView(image: "instagram", name: "@uwais.__alqadri")
            SocialMediaItemView(image: "gmail", name: "uwaisalqadri654321@gmail.com")
            SocialMediaItemView(image: "linkedin", name: "Uwais Alqadri")
            Divider()
              .padding(.top, 16)
          }
          .padding([.leading, .trailing], 24)

          VStack(alignment: .leading) {
            Text("about_me".localized())
              .font(.system(size: 18, weight: .medium, design: .rounded))
              .bold()

            Text("about_me_desc".localized())
              .padding(.top, 16)
          }
          .padding([.leading, .trailing], 24)

          Spacer()
        }
      }
      .padding(.bottom, 100)
      .navigationTitle("profile".localized())
    }.navigationViewStyle(StackNavigationViewStyle())
  }
}

struct AboutView_Previews: PreviewProvider {
  static var previews: some View {
    AboutView()
  }
}
