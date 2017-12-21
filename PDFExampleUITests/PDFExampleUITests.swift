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

  func testExample() {
    app.buttons["Read Financial Accounting"].tap()

    let pdfPdfviewNavigationBar = app.navigationBars["PDF.PDFView"]
    let bookmarksButton = pdfPdfviewNavigationBar.buttons["Bookmarks"]
    bookmarksButton.swipeLeft()

    bookmarksButton.tap()
    pdfPdfviewNavigationBar.buttons["Thumbnails"].tap()
    app/*@START_MENU_TOKEN@*/.collectionViews["Thumbnail Collection"].cells["Page 380,  Bookmarked"]/*[[".otherElements[\"PDF View\"].collectionViews[\"Thumbnail Collection\"]",".cells[\"Page 380,  Bookmarked\"]",".cells[\"Page 380\"]",".collectionViews[\"Thumbnail Collection\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,1]]@END_MENU_TOKEN@*/.tap()
    bookmarksButton.tap()
  }
    
}
