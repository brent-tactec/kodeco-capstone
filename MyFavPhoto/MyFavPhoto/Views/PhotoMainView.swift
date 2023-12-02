//
//  PhotoMainView.swift
//  MyFavPhoto
//
//  Created by Brent Reed on 2023-11-14.
//

import SwiftUI

struct PhotoMainView: View {

  var body: some View {
    TabView {
      PhotoSearchView()
        .tabItem {
          Label("Search", systemImage: "magnifyingglass")
        }
        .tag(0)

      PhotoFavView() // Assuming you'll implement this view later
        .tabItem {
          Label("Favorites", systemImage: "star.fill")
        }
        .tag(1)

      PhotoSettingsView()
        .tabItem {
          Label("Settings", systemImage:  "gearshape")
        }
        .tag(2)
    }
  }
}



#Preview {
  PhotoMainView()
}
