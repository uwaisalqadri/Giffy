//
//  AboutView.swift
//  GiphyGIF
//
//  Created by Uwais Alqadri on 29/05/21.
//

import SwiftUI
import Common

struct AboutView: ViewControllable {
  var holder: Common.NavStackHolder
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        HStack {
          Image("tampandanberani", bundle: Bundle.common)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 80, height: 80)
            .cornerRadius(20)

          VStack(alignment: .leading) {
            Text("Uwais Alqadri")
              .font(.system(size: 24))
              .bold()

            SocialMediaRow(image: "apple", name: "iOS Developer")
          }
          .padding(.leading)

          Spacer()
        }
        .padding(24)

        VStack(alignment: .leading) {
          SocialMediaRow(image: "instagram", name: "@uwais.__alqadri")
          SocialMediaRow(image: "gmail", name: "uwaisalqadri654321@gmail.com")
          SocialMediaRow(image: "linkedin", name: "Uwais Alqadri")
          Divider()
            .padding(.top, 16)
        }
        .padding([.leading, .trailing], 24)

        VStack(alignment: .leading) {
          Text(AboutString.labelAboutMe.localized)
            .font(.system(size: 18, weight: .medium, design: .rounded))
            .bold()

          Text(AboutString.labelAboutMeDesc.localized)
            .padding(.top, 16)
        }
        .padding([.leading, .trailing], 24)

        Spacer()
      }
    }
    .padding(.bottom, 100)
    .navigationTitle(AboutString.titleProfile.localized)
    .navigationViewStyle(StackNavigationViewStyle())
  }
}

struct AboutView_Previews: PreviewProvider {
  static var previews: some View {
    AboutView(holder: Injection.shared.resolve())
  }
}
