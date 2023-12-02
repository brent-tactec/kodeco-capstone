//
//  PhotoSettings.swift
//  MyFavPhoto
//
//  Created by Brent Reed on 2023-11-21.
//

import SwiftUI

struct PhotoSettings: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("layoutPreference") private var layoutPreference = "Grid"
    @AppStorage("wifiOnlyDownloads") private var wifiOnlyDownloads = false

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
            }
            .navigationBarTitle("Settings")
        }
        .environment(\.colorScheme, isDarkMode ? .dark : .light)
    }
}

#Preview {
    PhotoSettings()
}
