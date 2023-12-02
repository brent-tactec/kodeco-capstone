//
//  URLSessionProtocol.swift
//  MyFavPhoto
//
//  Created by Brent Reed on 2023-11-22.
//

import Foundation


protocol URLSessionProtocol {
  func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {
  func data(for request: URLRequest) async throws -> (Data, URLResponse) {
    return try await data(for: request, delegate: nil)
  }
}
