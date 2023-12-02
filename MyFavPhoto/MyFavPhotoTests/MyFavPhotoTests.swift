//
//  MyFavPhotoTests.swift
//  MyFavPhotoTests
//
//  Created by Brent Reed on 2023-11-13.
//
import XCTest
@testable import MyFavPhoto

// Helper function to create a mock photo
func createMockPhoto(id: Int) -> Photo {
  return Photo(
    alt: "Sample Photo",
    avgColor: "#FFFFFF",
    height: 800,
    id: id,
    liked: false,
    photographer: "John Doe",
    photographerId: 456,
    photographerURL: URL(string: "https://example.com"),
    src: PhotoSrc(
      landscape: URL(string: "https://example.com/landscape.jpg")!,
      large: URL(string: "https://example.com/large.jpg")!,
      large2x: URL(string: "https://example.com/large2x.jpg")!,
      medium: URL(string: "https://example.com/medium.jpg")!,
      original: URL(string: "https://example.com/original.jpg")!,
      portrait: URL(string: "https://example.com/portrait.jpg")!,
      small: URL(string: "https://example.com/small.jpg")!,
      tiny: URL(string: "https://example.com/tiny.jpg")!
    ),
    url: URL(string: "https://example.com/photo.jpg")!,
    width: 600
  )
}


// Photo Favorite Model Tests
class PhotoFavModelTests: XCTestCase {
  
  var sut: PhotoFavModel!
  
  override func setUp() {
    super.setUp()
    sut = PhotoFavModel()
  }
  
  override func tearDown() {
    sut = nil
    super.tearDown()
  }
  
  func testAddFavorite() {
    let photo = createMockPhoto(id: 1)
    sut.addFavorite(photo: photo)
    XCTAssertTrue(sut.favorites.contains(where: { $0.id == photo.id }), "Photo should be added to favorites")
  }
  
  func testRemoveFavorite() {
    let photo = createMockPhoto(id: 1)
    sut.addFavorite(photo: photo)
    sut.removeFavorite(photo: photo)
    XCTAssertFalse(sut.favorites.contains(where: { $0.id == photo.id }), "Photo should be removed from favorites")
  }
  
  func testIsFavorite() {
    let photo = createMockPhoto(id: 1)
    sut.addFavorite(photo: photo)
    XCTAssertTrue(sut.isFavorite(photo: photo), "isFavorite should return true for a favorite photo")
  }
  
  func testCountFavoritePhotos() {
    let photo1 = createMockPhoto(id: 1)
    let photo2 = createMockPhoto(id: 2)
    let photo3 = createMockPhoto(id: 3)
    
    sut.addFavorite(photo: photo1)
    sut.addFavorite(photo: photo2)
    sut.addFavorite(photo: photo3)
    
    XCTAssertEqual(sut.favorites.count, 3, "There should be 3 photos in favorites")
  }
  
}

// Photo Network Tests
class MockPhotoNetwork: PhotoNetworkingProtocol {
  var mockResponse: PhotoResponse?
  var mockError: Error?
  
  func searchPhotos(with url: URL) async throws -> PhotoResponse {
    if let error = mockError {
      throw error
    }
    if let response = mockResponse {
      return response
    } else {
      throw PhotoNetwork.NetworkError.dataError
    }
  }
  
}


// PhotoStore Tests
class PhotoStoreTests: XCTestCase {
  
  var photoStore: PhotoStore!
  var mockNetwork: MockPhotoNetwork!
  
  @MainActor override func setUp() {
    super.setUp()
    mockNetwork = MockPhotoNetwork()
    photoStore = PhotoStore()
  }
  
  override func tearDown() {
    photoStore = nil
    mockNetwork = nil
    super.tearDown()
  }
  
  func testFetchPhotos() async {
    let mockPhotos = [createMockPhoto(id: 1), createMockPhoto(id: 1)]
    let mockResponse = PhotoResponse(page: 1, perPage: 2, totalResults: 2, next_page: nil, prev_page: nil, photos: mockPhotos)
    mockNetwork.mockResponse = mockResponse
    
    await photoStore.fetchPhotos(query: "test")
    
    await MainActor.run {
      XCTAssertNotEqual(photoStore.photos.count, mockPhotos.count, "Photos should be fetched successfully")
    }
    
    // Test for handling invalid URL error
    func testHandleNetworkErrorInvalidURL() async {
      mockNetwork.mockError = PhotoNetwork.NetworkError.invalidURL
      await photoStore.fetchPhotos(query: "test")
      await MainActor.run {
        XCTAssertNil(photoStore.errorMessage, "Invalid URL", file: "Error message should indicate an invalid URL")
      }
    }
    
    // Test for handling invalid response and data error
    func testHandleNetworkErrorInvalidResponse() async {
      mockNetwork.mockError = PhotoNetwork.NetworkError.invalidResponse
      await photoStore.fetchPhotos(query: "test")
      await MainActor.run {
        XCTAssertEqual(photoStore.errorMessage, "Network error occurred", "Error message should indicate a network error")
      }
    }
    
    // Test for handling invalid status code error
    func testHandleNetworkErrorInvalidStatusCode() async {
      let statusCode = 404 // Example status code
      mockNetwork.mockError = PhotoNetwork.NetworkError.invalidStatusCode(statusCode)
      await photoStore.fetchPhotos(query: "test")
      await MainActor.run {
        XCTAssertEqual(photoStore.errorMessage, "Error with status code: \(statusCode)", "Error message should indicate an invalid status code")
      }
    }
    
    // Test for handling decoding error
    func testHandleNetworkErrorDecodingError() async {
      mockNetwork.mockError = PhotoNetwork.NetworkError.decodingError(NSError(domain: "", code: 0))
      await photoStore.fetchPhotos(query: "test")
      await MainActor.run {
        XCTAssertEqual(photoStore.errorMessage, "Error decoding data", "Error message should indicate a decoding error")
      }
    }
    
    // Test for handling unknown error
    func testHandleNetworkErrorUnknownError() async {
      mockNetwork.mockError = NSError(domain: "TestError", code: 0) // Simulate an unknown error
      await photoStore.fetchPhotos(query: "test")
      await MainActor.run {
        XCTAssertEqual(photoStore.errorMessage, "Unknown error occurred", "Error message should indicate an unknown error")
      }
    }
    
  }
}

// Asynchoronus Testing
class AsynchronousTestCase: XCTestCase {
  
  var photoNetwork: PhotoNetwork!
  
  @MainActor override func setUp() {
    super.setUp()
    photoNetwork = PhotoNetwork(session: URLSession.shared)
  }
  
  override func tearDown() {
    photoNetwork = nil
    super.tearDown()
  }
  
  func testServerResponse() {
    let expectation = self.expectation(description: "Server response in reasonable time")
    
    guard let url = URL(string: "https://api.pexels.com/v1/search?query=Cows&page=1&per_page=5") else {
      XCTFail("Invalid URL")
      return
    }
    
    Task {
      do {
        let response = try await photoNetwork.searchPhotos(with: url)
        XCTAssertNotNil(response, "Expected non-nil response, URL: \(url)")
        expectation.fulfill()
      } catch {
        XCTFail("Error: \(error.localizedDescription), URL: \(url)")
      }
    }
    
    waitForExpectations(timeout: 5)
  }
  
  
  @MainActor func testMoveDownloadedFile() throws {
    // Create a temporary file
    let tempFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString)
    let testData = Data("Test data".utf8)
    try testData.write(to: tempFileURL)
    
    
    let movedFileURL = try photoNetwork.moveDownloadedFile(tempFileURL)
    
    
    XCTAssertTrue(FileManager.default.fileExists(atPath: movedFileURL.path), "File should exist at new location")
    XCTAssertFalse(FileManager.default.fileExists(atPath: tempFileURL.path), "File should not exist at original location")
    
    // Clean up
    try FileManager.default.removeItem(at: movedFileURL)
  }
  
  // hybrid async and queue API test
  func testIsConnectedToWiFi() async {
    let mockNetworkMonitor = MockNetworkMonitor()
    mockNetworkMonitor.mockWiFiConnected = true // or false to simulate no Wi-Fi
    let isConnected = await mockNetworkMonitor.isConnectedToWiFi()
    XCTAssertEqual(isConnected, mockNetworkMonitor.mockWiFiConnected, "isConnectedToWiFi should return the mock value")
  }
}
