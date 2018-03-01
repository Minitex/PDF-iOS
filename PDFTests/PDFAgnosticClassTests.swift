//
//  PDFAgnosticClassTests.swift
//  PDFTests
//
//  Created by Vui Nguyen on 3/1/18.
//  Copyright © 2018 Minitex. All rights reserved.
//

import XCTest
@testable import PDF
@testable import PSPDFKit
@testable import PSPDFKitUI

class PDFAgnosticClassTests: XCTestCase {
  // swiftlint:disable trailing_whitespace
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
    
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
    
  func testImportDefaultAnnotations() {
    let mockData = MockData()
    let pdfViewControllerDelegate = MockPDFViewControllerDelegate(mockPDFViewControllerDelegateDelegate: mockData)
    let pdfViewController: PDFViewController? = PDFViewController.init(documentURL: mockData.documentURL,
                                                                       openToPage: mockData.lastPageRead,
                                                                       bookmarks: mockData.bookmarkPages,
                                                                       annotations: mockData.annotations,
                                                                       PSPDFKitLicense: MockAPIKeys.PDFLicenseKey,
                                                                       delegate: pdfViewControllerDelegate)

    XCTAssertFalse((pdfViewController?.document?.containsAnnotations)!, "there should be no annotations")
  }

  /*
  func testPerformanceExample() {
  // This is an example of a performance test case.
    self.measure {
    // Put the code you want to measure the time of here.
    }
  }
 */
}
