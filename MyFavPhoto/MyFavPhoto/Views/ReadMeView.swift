//
//  ReadMeView.swift
//  MyFavPhoto
//
//  Created by Brent Reed on 2023-11-21.
//


import SwiftUI

struct ReadMeView: View {
  var onStart: () -> Void
  var isFromSettings: Bool
  
  var body: some View {
    VStack {
      Text("Welcome to MyFavPhoto!")
        .font(.title)
        .foregroundColor(Color(hue: 0.542, saturation: 1.0, brightness: 0.957, opacity: 0.893))
        .padding()
      
      Text("Here's how to use the app:")
        .font(.title2)
        .fontWeight(.semibold)
        .padding(.bottom, 5)
      
      VStack(alignment: .leading) {
        HStack {
          Image(systemName: "magnifyingglass")
            .foregroundColor(.blue)
          Text("Search for photos on any topic or category.")
        }
        .padding(.bottom, 2)
        
        HStack {
          Image(systemName: "star.fill")
            .foregroundColor(.yellow)
          Text("Select and view your favorite photos.")
        }
        .padding(.bottom, 2)
        
        HStack {
          Image(systemName: "gearshape")
            .foregroundColor(.gray)
          Text("Customize settings like dark/light mode and photo view and downloading options.")
        }
      }
      
      Text("This app allows you to search for photos on any topic or category. A small photo is presented in a list of photos found based on your search. You can then select the photo for a larger view of the photo and select this photo to view later under your favourites.")
        .multilineTextAlignment(.leading)
        .padding()
      
      
      if isFromSettings {
        Button("Dismiss") {
          onStart()  // This will dismiss the view when called from settings
        }
        .padding()
        .foregroundColor(.white)
        .background(Color.blue)
        .cornerRadius(10)
      } else {
        HStack {
          Spacer()
          Button("Get Started") {
            onStart()
          }
          .accessibilityIdentifier("Get Started")
          .padding()
          .foregroundColor(.white)
          .background(Color.blue)
          .cornerRadius(10)
          Spacer()
        }
      }
    }
    .padding()
  }
}

#Preview {
  ReadMeView(onStart: {}, isFromSettings: false)
}
