//
//  Technical_Test_MovieUITests.swift
//  Technical Test MovieUITests
//
//  Created by Yusron Alfauzi on 21/05/25.
//

import XCTest

final class Technical_Test_MovieUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        
        let title = app.staticTexts["Movies"]
        XCTAssertTrue(title.exists)
        
        let elementsQuery = app.otherElements
        elementsQuery.element(boundBy: 6).tap()
        
        app/*@START_MENU_TOKEN@*/.staticTexts["Play trailer"]/*[[".buttons[\"Play trailer\"].staticTexts.firstMatch",".buttons.staticTexts[\"Play trailer\"]",".staticTexts[\"Play trailer\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        sleep(3)
        app/*@START_MENU_TOKEN@*/.staticTexts["Review"]/*[[".cells.staticTexts[\"Review\"]",".staticTexts[\"Review\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp(velocity: .fast)
        app.swipeUp(velocity: .fast)
        app.swipeUp(velocity: .fast)
        sleep(2)
        app/*@START_MENU_TOKEN@*/.staticTexts["Back"]/*[[".buttons[\"Back\"].staticTexts.firstMatch",".buttons.staticTexts[\"Back\"]",".staticTexts[\"Back\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let element = elementsQuery.element(boundBy: 11)
        element.swipeUp(velocity: .fast)
        element.swipeUp(velocity: .fast)
        element.swipeUp(velocity: .fast)
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
