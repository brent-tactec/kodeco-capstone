import Foundation
import SwiftUI

@MainActor
class PhotoStore: ObservableObject {
  var network = PhotoNetwork()  // Instance of PhotoNetwork
  @Published var photos: [Photo] = []
  @Published var currentPageURL: URL? = nil
  @Published var nextPageURL: URL? = nil
  @Published var prevPageURL: URL? = nil
  @Published var errorMessage: String?

  func fetchPhotos(query: String? = nil, pageURL: URL? = nil) {
    let urlToUse: URL?
    if let pageURL = pageURL {
      self.prevPageURL = self.currentPageURL
      urlToUse = pageURL
    } else if let query = query {
      urlToUse = constructSearchURL(query: query, page: 1)
      self.prevPageURL = nil
    } else {
      return
    }

    fetchPhotosFromURL(urlToUse)
  }

  private func constructSearchURL(query: String, page: Int) -> URL? {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "api.pexels.com"
    components.path = "/v1/search"
    components.queryItems = [
      URLQueryItem(name: "query", value: query),
      URLQueryItem(name: "page", value: String(page)),
      URLQueryItem(name: "per_page", value: "25")
    ]
    return components.url
  }

  private func fetchPhotosFromURL(_ url: URL?) {
    guard let url = url else {
      errorMessage = "Invalid URL"
      return
    }

    Task {
      do {
        let response = try await network.searchPhotos(with: url)
        self.currentPageURL = url
        self.photos = response.photos
        self.nextPageURL = response.next_page
      } catch {
        handleNetworkError(error)
      }
    }
  }

  private func handleNetworkError(_ error: Error) {
    if let networkError = error as? PhotoNetwork.NetworkError {
      switch networkError {
      case .invalidURL:
        errorMessage = "Invalid URL"
      case .invalidResponse, .dataError:
        errorMessage = "Network error occurred"
      case .invalidStatusCode(let statusCode):
        errorMessage = "Error with status code: \(statusCode)"
      case .decodingError:
        errorMessage = "Error decoding data"
      case .noWiFiConnection:
        errorMessage = "No wifi is connected"
      }

    } else {
      errorMessage = "Unknown error occurred"
    }
  }
}
