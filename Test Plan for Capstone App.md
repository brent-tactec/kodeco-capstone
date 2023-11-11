# Test Plan for Capstone App

## Introduction
The purpose of this test plan is to ensure that our capstone app meets the required functionality and quality standards. We will perform both unit and UI testing to validate the behavior of the app and achieve a minimum of 50% code coverage.

## Test Environment

### Xcode 14.3 (or the specified version).

### iOS 16.x (or the specified version).

### XCTest for unit testing.

### XCTest for UI testing.

## Test Objectives

### Verify that the app meets all the required functionality criteria mentioned in the project description.

### Ensure that the app's UI components work correctly in different orientations and dark/light modes.

### Confirm that the app handles errors gracefully and provides clear user feedback.

### Validate that the app uses Swift Modern Concurrency and follows MVVM architecture.

## Test Cases

### Unit Tests
- Networking Tests
	- Test network calls using URLSession to download/upload data.
	- Verify that API calls return expected data or handle low request limits gracefully.
	- Confirm that no API keys or authentication information are stored in the repository.
- Data Saving Tests
	- Test data saving functionality using user defaults, plist, file, or keychain.
	- Ensure that data is saved and retrieved correctly.
- Concurrency Tests
	- Verify that Swift Modern Concurrency (async/await and MainActor) is used appropriately.
	- Test that slow-running tasks are off the main thread.
	- Confirm that UI updates are performed on the main thread.
- Model Tests
	- Test the Model's ObservableObject and Published value(s).
	- Ensure that views correctly subscribe to and display data changes.
- Error Handling Tests
	- Test error handling for network calls, including server error response codes and no network connection.
	- Confirm that the app communicates errors to the user effectively.

### UI Tests
- List View Tests
	- Verify that the list view displays data correctly.
	- Test tapping list items to navigate to detail views.
	- Check that detail views display additional information accurately.
- Orientation and Dark/Light Mode Tests
	- Ensure that views work correctly in both landscape and portrait orientations.
	- Confirm that views adapt to both light and dark modes.
- Custom UI Tests
	- Test custom UI components, such as the app icon, onboarding screen, and custom display name.
	- Verify that SwiftUI animations are functional.
	- Check styled text properties and SwiftUI modifiers.
- Launch Screen Tests
	- Confirm that the launch screen is suitable for the app.
	- Test both static and animated launch screens, if applicable.
	- Measure code coverage during unit and UI testing.
	- Ensure that code coverage is at least 50%.
	- Report test results, including passed and failed tests, and any identified issues.
	- Include screenshots or descriptions of UI issues, if any.

## Test Coverage

## Test Reporting

## Conclusion
This test plan outlines the testing strategy to ensure that the capstone app meets the project requirements and quality standards. By performing comprehensive testing, including unit and UI tests, we aim to deliver a reliable and fully functional application.
