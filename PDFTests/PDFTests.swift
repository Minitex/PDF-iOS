//
//  PDFTests.swift
//  PDFTests
//
//  Created by Vui Nguyen on 11/14/17.
//  Copyright © 2017 Minitex. All rights reserved.
//
import XCTest
@testable import PDF
@testable import PSPDFKit
@testable import PSPDFKitUI

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

  // because openToPage only takes in UInt, we can't pass in a negative number, but what happens
  // if we pass in a number > number of pages in book? It should open the first page
  func testMuchTooLargeLastPageRead() {
    let mockData = MockData()
    let pdfViewControllerDelegate = MockPDFViewControllerDelegate(mockPDFViewControllerDelegateDelegate: mockData)
    let pdfViewController: PDFViewController? = PDFViewController.init(documentURL: mockData.documentURL,
                                                                       openToPage: 1000,
                                                                       bookmarks: mockData.bookmarkPages,
                                                                       annotations: mockData.annotationsData,
                                                                       PSPDFKitLicense: MockAPIKeys.PDFLicenseKey,
                                                                       delegate: pdfViewControllerDelegate)
    XCTAssert(pdfViewController?.pageIndex == 0, "last page read is not correct")
  }

  // what if we had 90 pages, so the last page index should be 89? But we pass in a page index of 90.
  // It should open the first page
  func testBarelyTooLargeLastPageRead() {
    let mockData = MockData()
    let pdfViewControllerDelegate = MockPDFViewControllerDelegate(mockPDFViewControllerDelegateDelegate: mockData)
    let pdfViewController: PDFViewController? = PDFViewController.init(documentURL: mockData.documentURL,
                                                                       openToPage: 90,
                                                                       bookmarks: mockData.bookmarkPages,
                                                                       annotations: mockData.annotationsData,
                                                                       PSPDFKitLicense: MockAPIKeys.PDFLicenseKey,
                                                                       delegate: pdfViewControllerDelegate)
    XCTAssert(pdfViewController?.pageIndex == 0, "last page read is not correct")
  }

  // what happens if we try to open exactly the last page of the book? It should still work
  func testExactlyLastPageForLastPageRead() {
    let mockData = MockData()
    let pdfViewControllerDelegate = MockPDFViewControllerDelegate(mockPDFViewControllerDelegateDelegate: mockData)
    let pdfViewController: PDFViewController? = PDFViewController.init(documentURL: mockData.documentURL,
                                                                       openToPage: 89,
                                                                       bookmarks: mockData.bookmarkPages,
                                                                       annotations: mockData.annotationsData,
                                                                       PSPDFKitLicense: MockAPIKeys.PDFLicenseKey,
                                                                       delegate: pdfViewControllerDelegate)
    XCTAssert(pdfViewController?.pageIndex == 89, "last page read is not correct")
  }


  // what if we add a bookmark?
  // remove a bookmark?

  func testImportBookmarks() {
    let mockData = MockData()
    let pdfViewControllerDelegate = MockPDFViewControllerDelegate(mockPDFViewControllerDelegateDelegate: mockData)
    let pdfViewController: PDFViewController? = PDFViewController.init(documentURL: mockData.documentURL,
                                                                       openToPage: mockData.lastPageRead,
                                                                       bookmarks: mockData.bookmarkPages,
                                                                       annotations: mockData.annotationsData,
                                                                       PSPDFKitLicense: MockAPIKeys.PDFLicenseKey,
                                                                       delegate: pdfViewControllerDelegate)

    XCTAssert((pdfViewController?.document?.bookmarks)! == [], "there should be no bookmarks")
  }


  // here we're adding a bookmark between app "closing" and "reopening"
  func testImportChangedBookmarks() {
    let mockData = MockData()
    let pdfViewControllerDelegate = MockPDFViewControllerDelegate(mockPDFViewControllerDelegateDelegate: mockData)
    var pdfViewController: PDFViewController? = PDFViewController.init(documentURL: mockData.documentURL,
                                                                       openToPage: mockData.lastPageRead,
                                                                       bookmarks: mockData.bookmarkPages,
                                                                       annotations: mockData.annotationsData,
                                                                       PSPDFKitLicense: MockAPIKeys.PDFLicenseKey,
                                                                       delegate: pdfViewControllerDelegate)

   // XCTAssert(pageNumbers.containsSameElements(as: mockData.bookmarkPages), "the bookmarks are not the same")
    XCTAssert((pdfViewController?.document?.bookmarks)! == [], "there should be no bookmarks")

    // this time, we're adding a bookmark before "closing and reopening" the app
    pdfViewController?.document?.bookmarkManager?.provider[0].add(PSPDFBookmark(pageIndex: 10))

    pdfViewController = nil
    pdfViewController = PDFViewController.init(documentURL: mockData.documentURL,
                                               openToPage: mockData.lastPageRead,
                                               bookmarks: mockData.bookmarkPages,
                                               annotations: mockData.annotationsData,
                                               PSPDFKitLicense: MockAPIKeys.PDFLicenseKey,
                                               delegate: pdfViewControllerDelegate)

    XCTAssert((pdfViewController?.document?.bookmarks)! != [], "there should be a bookmark here")
    XCTAssert((pdfViewController?.document?.bookmarkManager?.bookmarkForPage(at: 10)) != nil, "no bookmark exists for that page")
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

extension Array where Element: Comparable {
  func containsSameElements(as other: [Element]) -> Bool {
    return self.count == other.count && self.sorted() == other.sorted()
  }
}
