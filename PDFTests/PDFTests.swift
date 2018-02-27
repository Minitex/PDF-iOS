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

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testDefaultMockData() {
    checkMockDataLastPageRead()
    checkMockDataBookmarkPages()
    checkMockDataAnnotations()
  }

  func checkMockDataLastPageRead() {
    let mockData = MockData()
    XCTAssert(mockData.lastPageRead == 0, "last page read is wrong")
  }

  func checkMockDataBookmarkPages() {
    let mockData = MockData()
    XCTAssert(mockData.bookmarkPages == [], "bookmark pages are wrong")
  }

  func checkMockDataAnnotations() {
    let mockData = MockData()
    //XCTAssert(mockData.annotationsData == [Data(bytes: [8,9,10])], "annotations data is wrong")
    XCTAssert(mockData.annotationsData == [], "annotations data is wrong")
  }

  func testImportLastPageRead() {
    let mockData = MockData()
    let pdfViewControllerDelegate = MockPDFViewControllerDelegate(mockPDFViewControllerDelegateDelegate: mockData)
    let pdfViewController: PDFViewController? = PDFViewController.init(documentURL: mockData.documentURL,
                                                                       openToPage: mockData.lastPageRead,
                                                                       bookmarks: mockData.bookmarkPages,
                                                                       annotations: mockData.annotationsData,
                                                                       PSPDFKitLicense: MockAPIKeys.PDFLicenseKey,
                                                                       delegate: pdfViewControllerDelegate)
    XCTAssert(pdfViewController?.pageIndex == 0, "last page read is not correct")
  }

  // we are simulating opening the PDF view controller, changing the page number
  // and then opening a new PDF view controller to see if the new page number is imported
  // correctly between new versions of the PDF view controller (simulate opening, closing, and
  // re-opening the app)
  func testImportChangedLastPageRead() {
    let mockData: MockData? = MockData()
    let pdfViewControllerDelegate: MockPDFViewControllerDelegate = MockPDFViewControllerDelegate(mockPDFViewControllerDelegateDelegate: mockData!)
    var pdfViewController: PDFViewController? = PDFViewController.init(documentURL: (mockData?.documentURL)!,
                                                                       openToPage: (mockData?.lastPageRead)!,
                                                                       bookmarks: (mockData?.bookmarkPages)!,
                                                                       annotations: (mockData?.annotationsData)!,
                                                   PSPDFKitLicense: MockAPIKeys.PDFLicenseKey,
                                                   delegate: pdfViewControllerDelegate)
    XCTAssert(pdfViewController?.pageIndex == mockData?.lastPageRead, "last page read is not correct")

    let newPage = 12
    // Note: calling the PDFViewController's willbeingDisplaying (page turning method) directly doesn't work
    // so we're calling the delegate method that saves off the page number directly
    pdfViewControllerDelegate.userDidNavigate(page: newPage)
    pdfViewController = nil
    pdfViewController = PDFViewController.init(documentURL: (mockData?.documentURL)!,
                                               openToPage: (mockData?.lastPageRead)!,
                                               bookmarks: (mockData?.bookmarkPages)!,
                                               annotations: (mockData?.annotationsData)!,
                                               PSPDFKitLicense: MockAPIKeys.PDFLicenseKey,
                                               delegate: pdfViewControllerDelegate)
    XCTAssert(pdfViewController?.pageIndex == UInt(12), "last page read is not correct")
  }

  func testInvalidLastPageRead() {

  }

  func testBookmarks() {

  }

  func testAnnotations() {
    
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
