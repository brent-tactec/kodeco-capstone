//
//  PhotoNetworkingProtocol.swift
//  MyFavPhoto
//
//  Created by Brent Reed on 2023-11-16.
//

import Foundation

protocol PhotoNetworkingProtocol {
  func searchPhotos(with url: URL) async throws -> PhotoResponse
  
}

protocol NetworkMonitoring {
  func isConnectedToWiFi() async -> Bool
}

