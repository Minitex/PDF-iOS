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

  // can we test lastPageRead first? and how?

  // in order to test BookmarkProvider and AnnotationProvider, must create a PDFViewControllerDelegate
  let weak pdfViewControllerDelegate = MockPDFViewControllerDelegate()

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testExample() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }

  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }

}
