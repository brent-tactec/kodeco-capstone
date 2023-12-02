//
//  PhotoSettingsView.swift
//  MyFavPhoto
//
//  Created by Brent Reed on 2023-11-21.
//

import SwiftUI

struct PhotoSettingsView: View {
  @AppStorage("layoutPreference") var layoutPreference = "Grid"
  @AppStorage("wifiOnlyDownloads") private var wifiOnlyDownloads = false
  @AppStorage("isDarkMode") var isDarkMode = false
  @State private var showReadMeView = false
  
  let layoutOptions = ["Grid", "List", "Slide Show"]
  
  var body: some View {
    NavigationView {
      Form {
        // Dark/Light Mode Toggle
        Toggle(isOn: $isDarkMode) {
          Text("Dark Mode")
        }
        
        // Layout Selection
        Picker("Layout", selection: $layoutPreference) {
          ForEach(layoutOptions, id: \.self) { option in
            Text(option)
          }
        }
        .pickerStyle(SegmentedPickerStyle())
        
        // Data Usage Toggle
        Toggle(isOn: $wifiOnlyDownloads) {
          Text("Download Over Wi-Fi Only")
        }
        
        // ReadMe Button
        Button("Instructions") {
          showReadMeView = true
        }
      }
      .sheet(isPresented: $showReadMeView) {
        ReadMeView(onStart: {
          showReadMeView = false
        }, isFromSettings: true)
      }
      .environment(\.colorScheme, isDarkMode ? .dark : .light)
    }
  }
}

enum LayoutOption: String, CaseIterable {
  case grid = "Grid"
  case list = "List"
  case slideShow = "Slide Show"
}

#Preview {
  PhotoSettingsView()
}
