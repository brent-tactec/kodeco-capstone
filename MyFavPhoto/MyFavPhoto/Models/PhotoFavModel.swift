//
//  PhotoFavModel.swift
//  MyFavPhoto
//
//  Created by Brent Reed on 2023-11-14.
//

import Foundation

class PhotoFavModel: ObservableObject {
  
  @Published var favorites: [Photo] = []
  
  func addFavorite(photo: Photo) {
    if !favorites.contains(where: { $0.id == photo.id }) {
      favorites.append(photo)
    }
  }
  
  func removeFavorite(photo: Photo) {
    favorites.removeAll { $0.id == photo.id }
  }
  
  func isFavorite(photo: Photo) -> Bool {
    favorites.contains(where: { $0.id == photo.id })
  }
}


