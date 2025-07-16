import Foundation
import XCTest

class UITest: XCTestCase {

    let app = XCUIApplication()

    override  func setUp() {
        // Set environment variable for UI testing to use SampleData
        app.launchEnvironment["IS_UI_TESTING"] = "1"
        app.launch()
    }

    override func tearDown() {
        addDebugDescriptionAttachment(app)
        addScreenshot(app)
    }
}
