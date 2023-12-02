//
//  PhotoFavView.swift
//  MyFavPhoto
//
//  Created by Brent Reed on 2023-11-14.
//

import SwiftUI

struct PhotoFavView: View {
  @EnvironmentObject var photoFavModel: PhotoFavModel
  @AppStorage("layoutPreference") private var layoutPreferenceRawValue = LayoutOption.grid.rawValue
  @Environment(\.colorScheme) var colorScheme
  
  private var layoutPreference: LayoutOption {
    LayoutOption(rawValue: layoutPreferenceRawValue) ?? .grid
  }
  
  var body: some View {
    GeometryReader { geometry in
      ScrollView {
        VStack {
          Spacer()
          switch layoutPreference {
          case .grid:
            displayGrid()
          case .list:
            displayList()
          case .slideShow:
            displaySlideShow(geometry: geometry)
          }
          Spacer()
        }
        .frame(width: geometry.size.width, height: geometry.size.height)
      }
    }
    .navigationTitle("Favorites")
  }
  
  // Display photos in a grid layout
  private func displayGrid() -> some View {
    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
      photoCells
    }
  }
  
  // Display photos in a list layout
  private func displayList() -> some View {
    List(photoFavModel.favorites, id: \.id) { photo in
      photoCell(photo: photo)
    }
  }
  
  // Display photos in a slideshow layout
  private func displaySlideShow(geometry: GeometryProxy) -> some View {
    TabView {
      photoCells
    }
    .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.5) // Adjust size as needed
    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
    // .background(colorScheme == .dark ? Color.black : Color.white)
    
    .background(Color.gray.opacity(0.5))
    .cornerRadius(10)
    .padding()
    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
  }
  
  // Photo cells used in both grid and slideshow views
  private var photoCells: some View {
    ForEach(photoFavModel.favorites, id: \.id) { photo in
      photoCell(photo: photo)
        .frame(width: layoutPreference == .grid ? 100 : nil, height: layoutPreference == .grid ? 100 : 300)
    }
  }
  
  // Reusable photo cell
  private func photoCell(photo: Photo) -> some View {
    AsyncImage(url: photo.src.large) { phase in
      switch phase {
      case .success(let image):
        image.resizable().scaledToFit()
      case .empty:
        ProgressView()
      case .failure:
        Image(systemName: "photo")
      @unknown default:
        EmptyView()
      }
    }
  }
}

struct PhotoFavView_Previews: PreviewProvider {
  static var previews: some View {
    PhotoFavView().environmentObject(PhotoFavModel())
  }
}
