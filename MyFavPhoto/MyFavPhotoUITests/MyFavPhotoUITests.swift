//
//  MyFavPhotoUITests.swift
//  MyFavPhotoUITests
//
//  Created by Brent Reed on 2023-11-13.
//

import XCTest
@testable import MyFavPhoto


class MyFavPhotoUITests: XCTestCase {
  var app: XCUIApplication!
  override func setUpWithError() throws {
    app = .init()
    app.launch()

    // In UI tests stop immediately when a failure occurs.
    continueAfterFailure = false
  }

  func test_menu() throws {
    let masterTabBar = app.tabBars["Tab Bar"]
    let menuButton = masterTabBar.buttons["Search"]
    menuButton.tap()
    XCTAssert(masterTabBar.exists)
    XCTAssert(masterTabBar.buttons["Search"].exists)
  }
}

class PhotoSettingsViewUITests: XCTestCase {

  override func setUpWithError() throws {
    continueAfterFailure = false
  }

  func testInstructionsButton() {
    // Launch your app.
    let app = XCUIApplication()
    app.launch()

    // Navigate to the PhotoSettingsView.
    // For example, you can tap the "Settings" tab button if that's where your PhotoSettingsView is located.
    let settingsTabButton = app.tabBars["Tab Bar"].buttons["Settings"]
    XCTAssertTrue(settingsTabButton.exists)
    settingsTabButton.tap()

    // Verify that the "Instructions" button exists and tap it.
    let instructionsButton = app.buttons["Instructions"]
    XCTAssertTrue(instructionsButton.exists)
    instructionsButton.tap()
  }
}

class PhotoFavViewUITests: XCTestCase {

  override func setUpWithError() throws {
    continueAfterFailure = false
  }

  func testPhotoFavViewContent() {
    // Launch your app.
    let app = XCUIApplication()
    app.launch()

    // Navigate to the PhotoFavView.
    // For example, you can tap the "Favorites" tab button if that's where your PhotoFavView is located.
    let favoritesTabButton = app.tabBars["Tab Bar"].buttons["Favorites"]
    XCTAssertTrue(favoritesTabButton.exists)
    favoritesTabButton.tap()

    XCTAssertFalse(app.navigationBars["Favorites"].exists)

    let photoCell = app.cells["photoCell"]
    XCTAssertFalse(photoCell.exists)
  }
}

// if more time would add mock JSON data in a file and add to bundle

class PhotoDetailViewUITests: XCTestCase {

  override func setUpWithError() throws {
    continueAfterFailure = false
  }

  func testPhotoDetailViewContent() {
    // Launch the app.
    let app = XCUIApplication()
    app.launch()

    let favoritesTabButton = app.tabBars["Tab Bar"].buttons["Favorites"]
    XCTAssertTrue(favoritesTabButton.exists)
    favoritesTabButton.tap()

    let photoCell = app.cells["photoCell"]
    XCTAssertFalse(photoCell.exists)

    let photographerNameLabel = app.staticTexts["Photographer: PhotographerName"]
    XCTAssertFalse(photographerNameLabel.exists)

    let heartButton = app.buttons["heart"]
    XCTAssertFalse(heartButton.exists)

    let photographerURLLink = app.links["Photographer URL"]
    XCTAssertFalse(photographerURLLink.exists)

  }
}





