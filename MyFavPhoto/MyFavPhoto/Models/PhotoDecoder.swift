//
//  PhotoDecoder.swift
//  MyFavPhoto
//
//  Created by Brent Reed
//
// image / photo decoder

import Foundation

struct PhotoResponse: Codable {
  let page: Int
  let perPage: Int?
  let totalResults: Int?
  let next_page: URL?
  let prev_page: URL?
  let photos: [Photo]
}


struct Photo: Codable, Identifiable {
  let alt: String
  let avgColor: String?
  let height: Int
  let id: Int
  let liked: Bool
  let photographer: String
  let photographerId: Int?
  let photographerURL: URL?
  let src: PhotoSrc
  let url: URL
  let width: Int
}


struct PhotoSrc: Codable {
  let landscape: URL
  let large: URL
  let large2x: URL
  let medium: URL
  let original: URL
  let portrait: URL
  let small: URL
  let tiny: URL
}

