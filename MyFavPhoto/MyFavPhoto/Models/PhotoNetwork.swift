//
//  PhotoNetwork.swift
//  MyFavPhoto
//
//  Created by Brent Reed on 2023-11-13.
//

import Foundation
import SwiftUI
import Network

@MainActor
class PhotoNetwork: PhotoNetworkingProtocol {
  
  // API Key
  private var apiKey: String = ""
  private var session: URLSessionProtocol
  
  init(session: URLSessionProtocol = URLSession.shared) {
    self.session = session
    
    if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
       let config = NSDictionary(contentsOfFile: path) {
      apiKey = config["API_Key"] as? String ?? ""
    }
  }
  
  // Network function errors
  public enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidStatusCode(Int)
    case decodingError(Error)
    case dataError
    case noWiFiConnection
  }
  
  func searchPhotos(with url: URL) async throws -> PhotoResponse {
    let wifiOnly = UserDefaults.standard.bool(forKey: "wifiOnlyDownloads")
    
    // Check the Wi-Fi connection status outside the `if` condition
    let isConnected = wifiOnly ? (await isConnectedToWiFi()) : true
    
    if wifiOnly && !isConnected {
      throw NetworkError.noWiFiConnection
    }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue(apiKey, forHTTPHeaderField: "Authorization")
    print("request, \(request)")
    
    do {
      let (data, response) = try await session.data(for: request)
      
      guard let httpResponse = response as? HTTPURLResponse else {
        throw NetworkError.invalidResponse
      }
      
      guard (200..<300).contains(httpResponse.statusCode) else {
        throw NetworkError.invalidStatusCode(httpResponse.statusCode)
      }
      
      do {
        return try JSONDecoder().decode(PhotoResponse.self, from: data)
      } catch {
        throw NetworkError.decodingError(error)
      }
    } catch {
      throw NetworkError.dataError
    }
  }
  
  // Define DownloadProgress class
  class DownloadProgress: ObservableObject {
    @Published var value: Double = 0
  }
  
  func downloadImage(url: URL, progress: DownloadProgress) async throws -> UIImage {
    let wifiOnly = UserDefaults.standard.bool(forKey: "wifiOnlyDownloads")
    // Check the Wi-Fi connection status outside the `if` condition
    let isConnected = wifiOnly ? (await isConnectedToWiFi()) : true
    
    if wifiOnly && !isConnected {
      throw NetworkError.noWiFiConnection
    }
    
    
    let (tempFileURL, response) = try await URLSession.shared.download(from: url)
    let totalBytesToDownload = response.expectedContentLength
    
    var bytesReceived: Int64 = 0
    let destinationFileURL = try moveDownloadedFile(tempFileURL)
    
    if let inputStream = InputStream(url: destinationFileURL) {
      inputStream.open()
      defer { inputStream.close() }
      
      var receivedData = Data()
      let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 1024)
      defer { buffer.deallocate() }
      
      while inputStream.hasBytesAvailable {
        let bytesRead = inputStream.read(buffer, maxLength: 1024)
        if bytesRead > 0 {
          receivedData.append(buffer, count: bytesRead)
          bytesReceived += Int64(bytesRead)
          let newProgress = Double(bytesReceived) / Double(totalBytesToDownload)
          
          // Update progress on the main thread
          await MainActor.run {
            progress.value = newProgress
          }
        }
      }
      
      
      guard let image = UIImage(data: receivedData) else {
        throw NetworkError.dataError
      }
      return image
    } else {
      throw NetworkError.dataError
    }
  }
  
  func moveDownloadedFile(_ tempFileURL: URL) throws -> URL {
    let destinationFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString)
    try FileManager.default.moveItem(at: tempFileURL, to: destinationFileURL)
    return destinationFileURL
  }
  
  
  func isConnectedToWiFi() async -> Bool {
    await withCheckedContinuation { continuation in
      let monitor = NWPathMonitor()
      monitor.pathUpdateHandler = { path in
        let isConnected = path.status == .satisfied && path.usesInterfaceType(.wifi)
        continuation.resume(returning: isConnected)
        monitor.cancel()
      }
      monitor.start(queue: .main)
      
    }
  }
}

// for testing
class MockNetworkMonitor: NetworkMonitoring {
  // ... other methodsype 'MockNetworkMonitor' does not conform to protocol 'PhotoNetworkingProtocol'
  
  var mockWiFiConnected: Bool = true
  func isConnectedToWiFi() async -> Bool {
    return mockWiFiConnected
  }
}

