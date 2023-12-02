//
//  MyFavPhotoApp.swift
//  MyFavPhoto
//
//  Created by Brent Reed on 2023-11-13.
//

import SwiftUI


@main
struct MyFavPhotoApp: App {
  @State private var hasLaunchedBefore = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
  @AppStorage("isDarkMode") private var isDarkMode = false
  
  var body: some Scene {
    WindowGroup {
      if !hasLaunchedBefore {
        ReadMeView(onStart: {
          hasLaunchedBefore = true
          UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
        }, isFromSettings: false)
      } else {
        PhotoMainView()
          .environmentObject(PhotoFavModel())
          .environment(\.colorScheme, isDarkMode ? .dark : .light)
      }
    }
  }
}

