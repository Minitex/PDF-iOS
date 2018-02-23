//
//  PDFTests.swift
//  PDFTests
//
//  Created by Vui Nguyen on 11/14/17.
//  Copyright © 2017 Minitex. All rights reserved.
//

import XCTest
@testable import PDF

class PDFTests: XCTestCase {
  // swiftlint:disable trailing_whitespace

  // how to test bookmarks?
  // in order to test BookmarkProvider and AnnotationProvider, must create a PDFViewControllerDelegate
  var pdfViewControllerDelegate: PDFViewControllerDelegate? = nil

  var documentURL: URL? = nil
  var lastPageRead: UInt? = nil
  var bookmarkPages: [UInt]? = nil
  var annotationsData: [Data]? = nil

  // can we test lastPageRead first? and how?
  // create a PDFViewController, and then test that the pageIndex is indeed same as lastPageRead

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
    setupTestData()
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func setupTestData() {
    // this is where we select the test data we're going to use
    // ie what the last page read should be, bookmarks, annotations, etc.
    documentURL = MockData.documentURL()
    lastPageRead = MockData.lastPageRead
    bookmarkPages = MockData.bookmarkPages
    annotationsData = MockData.annotationsData
    pdfViewControllerDelegate = MockPDFViewControllerDelegate()
  }


  func testLastPageRead() {
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    let pdfViewController = PDFViewController.init(documentURL: documentURL!,
                                                   openToPage: lastPageRead!,
                                                   bookmarks: bookmarkPages!,
                                                   annotations: annotationsData!,
                                                   PSPDFKitLicense: MockAPIKeys.PDFLicenseKey,
                                                   delegate: pdfViewControllerDelegate)
    XCTAssert(pdfViewController.pageIndex == 0, "last page read is not correct")
  }


  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }

}
