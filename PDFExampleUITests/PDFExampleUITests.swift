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

  // test if we're on a certain page or not
  func testExample() {
    app.buttons["Read Financial Accounting"].tap()

    let pdfPdfviewNavigationBar = app.navigationBars["PDF.PDFView"]
    let bookmarksButton = pdfPdfviewNavigationBar.buttons["Bookmarks"]
    bookmarksButton.swipeLeft()

    bookmarksButton.tap()
    pdfPdfviewNavigationBar.buttons["Thumbnails"].tap()
    app/*@START_MENU_TOKEN@*/.collectionViews["Thumbnail Collection"].cells["Page 380"]/*[[".otherElements[\"PDF View\"].collectionViews[\"Thumbnail Collection\"]",".cells[\"Page 380,  Bookmarked\"]",".cells[\"Page 380\"]",".collectionViews[\"Thumbnail Collection\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()

    XCTAssertFalse(app/*@START_MENU_TOKEN@*/.collectionViews["Thumbnail Collection"].cells["Page 380"]/*[[".otherElements[\"PDF View\"].collectionViews[\"Thumbnail Collection\"]",".cells[\"Page 380,  Bookmarked\"]",".cells[\"Page 380\"]",".collectionViews[\"Thumbnail Collection\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.exists, "This page exists")
    bookmarksButton.tap()
  }

  // test if we're on a certain page or not
  func test2Example() {

    app.buttons["Read Financial Accounting"].tap()

    let pdfPdfviewNavigationBar = app.navigationBars["PDF.PDFView"]
    let thumbnailsButton = pdfPdfviewNavigationBar.buttons["Thumbnails"]
    thumbnailsButton.tap()

    let thumbnailCollectionCollectionView = app/*@START_MENU_TOKEN@*/.collectionViews["Thumbnail Collection"]/*[[".otherElements[\"PDF View\"].collectionViews[\"Thumbnail Collection\"]",".collectionViews[\"Thumbnail Collection\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
    thumbnailCollectionCollectionView.cells["Page 367"].tap()
    app/*@START_MENU_TOKEN@*/.staticTexts["367 of 620"]/*[[".otherElements[\"PDF View\"]",".otherElements[\"User Interface View\"].staticTexts[\"367 of 620\"]",".staticTexts[\"367 of 620\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
    XCTAssertTrue(app.staticTexts["367 of 620"].exists, "Currently on this page")

   // pdfPdfviewNavigationBar.buttons["Bookmarks"].tap()
   // thumbnailsButton.tap()
   // thumbnailCollectionCollectionView/*@START_MENU_TOKEN@*/.cells["Page 367"]/*[[".cells[\"Page 367,  Bookmarked\"]",".cells[\"Page 367\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
  }

  // Next, how do we test that the bookmark icon is "on" for a page?

}
