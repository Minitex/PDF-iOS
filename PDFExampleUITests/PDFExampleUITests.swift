//
//  PDFExampleUITests.swift
//  PDFExampleUITests
//
//  Created by Vui Nguyen on 11/14/17.
//  Copyright © 2017 Minitex. All rights reserved.
//

import XCTest

class PDFExampleUITests: XCTestCase {

  var app: XCUIApplication!

  override func setUp() {
    super.setUp()
    continueAfterFailure = false
    app = XCUIApplication()
    app.launch()
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testGoToPage() {
    app.buttons["Read Financial Accounting"].tap()
    app.navigationBars["PDF.PDFView"].buttons["Outline"].tap()

    app.tables["Outline Menu"]/*@START_MENU_TOKEN@*/.staticTexts["Publisher Information"]/*[[".cells.staticTexts[\"Publisher Information\"]",".staticTexts[\"Publisher Information\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    //app/*@START_MENU_TOKEN@*/.staticTexts["10 of 620"]/*[[".otherElements[\"PDF View\"]",".otherElements[\"User Interface View\"].staticTexts[\"10 of 620\"]",".staticTexts[\"10 of 620\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
    XCTAssertTrue(app.staticTexts["10 of 620"].exists, "Currently on this page")
  }

  func testLastPageRead() {
    app.buttons["Read Financial Accounting"].tap()
    XCTAssertTrue(app.staticTexts["10 of 620"].exists, "Currently on this page")
  }

  func testAddBookmark() {
    app.buttons["Read Financial Accounting"].tap()
    let outlineButton = app.navigationBars.buttons["Outline"]
    outlineButton.tap()
    app.navigationBars["Outline"].buttons["Bookmarks"].tap()

    app.toolbars.buttons["Add"].tap()
    // Assert that what was tapped was added to the Bookmarks table of contents

  }

  func testRemoveBookmark() {
    app.buttons["Read Financial Accounting"].tap()
    let outlineButton = app.navigationBars.buttons["Outline"]
    outlineButton.tap()
    app.navigationBars["Outline"].buttons["Bookmarks"].tap()

    let cell = app.tables.cells.element(boundBy: 0)
    let cellLabel = cell.label
    cell.swipeLeft()
    app.tables.buttons["Delete"].tap()
    // Assert that the row was indeed removed
  }

  func testAddAndRemoveBookmark() {

  }

}
