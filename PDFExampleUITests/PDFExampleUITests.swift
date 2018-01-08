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
    // line below is needed to work on iPad device
    app.navigationBars["Financial Accounting"].buttons["Outline"].tap()

    // line below works on simulator
    //app.navigationBars["PDF.PDFView"].buttons["Outline"].tap()

    app.tables["Outline Menu"]/*@START_MENU_TOKEN@*/.staticTexts["Publisher Information"]/*[[".cells.staticTexts[\"Publisher Information\"]",".staticTexts[\"Publisher Information\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

    XCUIDevice.shared.press(XCUIDevice.Button.home)
    XCUIApplication().terminate()
    XCUIApplication().launch()

    app.buttons["Read Financial Accounting"].tap()
    // line below is needed to work on iPad device
    let pdfPageViewElement = app/*@START_MENU_TOKEN@*/.scrollViews["PDF Culling View"].otherElements.collectionViews.children(matching: .cell).matching(identifier: "PDF Spread Cell Scroll View").element(boundBy: 1).scrollViews.otherElements.otherElements["PDF Page View"]/*[[".otherElements[\"PDF View\"]",".otherElements[\"PDF Document View\"].scrollViews[\"PDF Culling View\"].otherElements.collectionViews.children(matching: .cell).matching(identifier: \"PDF Spread Cell Scroll View\").element(boundBy: 1).scrollViews.otherElements",".otherElements[\"PDF Spread View\"].otherElements[\"PDF Page View\"]",".otherElements[\"PDF Page View\"]",".scrollViews[\"PDF Culling View\"].otherElements.collectionViews.children(matching: .cell).matching(identifier: \"PDF Spread Cell Scroll View\").element(boundBy: 1).scrollViews.otherElements"],[[[-1,4,2],[-1,1,2],[-1,0,1]],[[-1,4,2],[-1,1,2]],[[-1,3],[-1,2]]],[0,0]]@END_MENU_TOKEN@*/
    pdfPageViewElement.tap()
    XCTAssertTrue(app.staticTexts["10 of 620"].exists, "Currently on this page")
  }

  // this test only works if the bookmark doesn't already exist
  // if the bookmark already exists, the test fails
  /*
  func testAddOneBookmark() {
    app.buttons["Read Financial Accounting"].tap()

    // before going to the outline, grab the current page number
    // How to do that??

    let outlineButton = app.navigationBars.buttons["Outline"]
    outlineButton.tap()
    app.navigationBars["Outline"].buttons["Bookmarks"].tap()

    // get current number of rows in table
    let numRows = app.cells.count

    app.toolbars.buttons["Add"].tap()
    // Assert that what was tapped was added to the Bookmarks table of contents
    // check that the number of rows was increased by 1

    // we should try checking to see if that page number exists in the list, whether it already exists or
    // is recently added, the assertion below is not robust
    XCTAssertTrue(app.cells.count == numRows + 1, "added additional row")
  }
 */

  func testAddCorrectBookmark() {

  }

  func testRemoveBookmark() {
    app.buttons["Read Financial Accounting"].tap()
    let outlineButton = app.navigationBars.buttons["Outline"]
    outlineButton.tap()
    app.navigationBars["Outline"].buttons["Bookmarks"].tap()

    if (app.tables.cells.count > 0) {
      let cell = app.tables.cells.element(boundBy: 0)
      let cellLabel = app.tables.staticTexts.element(boundBy: 0).label
      cell.swipeLeft()
      app.tables.buttons["Delete"].tap()
      // Assert that the row was indeed removed
      XCTAssertFalse(app.tables.staticTexts[cellLabel].exists, "bookmark removed")
    }
  }

  /*
  // add and immediately remove that same bookmark
  func testAddAndRemoveBookmark() {
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
 */

  func testOpenCloseOpenApp() {

    let app = XCUIApplication()
    app.buttons["Read Financial Accounting"].tap()

    XCUIDevice.shared.press(XCUIDevice.Button.home)
    XCUIApplication().terminate()
    XCUIApplication().launch()

  }

}
