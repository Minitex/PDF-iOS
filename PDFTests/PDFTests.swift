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

  func testImportDefaultLastPageRead() {
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
    let pdfViewControllerDelegate: MockPDFViewControllerDelegate =
      MockPDFViewControllerDelegate(mockPDFViewControllerDelegateDelegate: mockData!)
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
    XCTAssert(pdfViewController?.pageIndex == UInt(newPage), "last page read is not correct")
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

  func testImportDefaultBookmarks() {
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

  // here we're ADDING a bookmark between app "closing" and "reopening"
  func testImportAddedBookmarks() {
    let mockData = MockData()
    let pdfViewControllerDelegate = MockPDFViewControllerDelegate(mockPDFViewControllerDelegateDelegate: mockData)
    var pdfViewController: PDFViewController? = PDFViewController.init(documentURL: mockData.documentURL,
                                                                       openToPage: mockData.lastPageRead,
                                                                       bookmarks: mockData.bookmarkPages,
                                                                       annotations: mockData.annotationsData,
                                                                       PSPDFKitLicense: MockAPIKeys.PDFLicenseKey,
                                                                       delegate: pdfViewControllerDelegate)

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
    XCTAssert((pdfViewController?.document?.bookmarkManager?.bookmarkForPage(at: 10)) != nil,
              "no bookmark exists for that page")
  }

  // test REMOVING a bookmark between app "closing" and "reopening"
  func testImportDeletedBookmarks() {

  }

  func testImportDefaultAnnotations() {
    let mockData = MockData()
    let pdfViewControllerDelegate = MockPDFViewControllerDelegate(mockPDFViewControllerDelegateDelegate: mockData)
    let pdfViewController: PDFViewController? = PDFViewController.init(documentURL: mockData.documentURL,
                                                                       openToPage: mockData.lastPageRead,
                                                                       bookmarks: mockData.bookmarkPages,
                                                                       annotations: mockData.annotationsData,
                                                                       PSPDFKitLicense: MockAPIKeys.PDFLicenseKey,
                                                                       delegate: pdfViewControllerDelegate)

    XCTAssertFalse((pdfViewController?.document?.containsAnnotations)!, "there should be no annotations")
  }

  // verify that a highlight annotation was created between app "closing" and "re-opening"
  func testImportHighlightAnnotation() {
    let mockData = MockData()
    let pdfViewControllerDelegate = MockPDFViewControllerDelegate(mockPDFViewControllerDelegateDelegate: mockData)
    var pdfViewController: PDFViewController? = PDFViewController.init(documentURL: mockData.documentURL,
                                                                       openToPage: mockData.lastPageRead,
                                                                       bookmarks: mockData.bookmarkPages,
                                                                       annotations: mockData.annotationsData,
                                                                       PSPDFKitLicense: MockAPIKeys.PDFLicenseKey,
                                                                       delegate: pdfViewControllerDelegate)

    XCTAssertFalse((pdfViewController?.document?.containsAnnotations)!, "there should be no annotations")

    // Now, create a new highlight annotation
    let annotationPage = 11
    let highlightAnnotation = PSPDFHighlightAnnotation()

    // Define where you want to place the annotation in the document (required)
    let boundingBox = CGRect(x: 57.174533843994141, y: 320.77774047851562,
                             width: 323.84738159179688, height: 23.301727294921875)
    highlightAnnotation.boundingBox = boundingBox

    // For highlight annotations you also need to set the rects array accordingly (required)
    highlightAnnotation.rects = [NSValue(cgRect: boundingBox)]
    // and which page you want the annotation to appear on (required)
    highlightAnnotation.pageIndex = UInt(annotationPage)

    // color and alpha are optional, alpha is opacity
    highlightAnnotation.color = UIColor.yellow
    highlightAnnotation.alpha = 1.0

    // Add the newly created annotation to the document
    pdfViewController?.document?.add([highlightAnnotation], options: nil)

    pdfViewController = nil
    pdfViewController = PDFViewController.init(documentURL: mockData.documentURL,
                                               openToPage: mockData.lastPageRead,
                                               bookmarks: mockData.bookmarkPages,
                                               annotations: mockData.annotationsData,
                                               PSPDFKitLicense: MockAPIKeys.PDFLicenseKey,
                                               delegate: pdfViewControllerDelegate)

    XCTAssertTrue((pdfViewController?.document?.containsAnnotations)!, "there should an annotation")
    XCTAssertTrue(((pdfViewController?.document?.annotationsForPage(at: UInt(annotationPage),
                    type: PSPDFAnnotationType.highlight)) != nil),
                   "should be an annotation on this page")
  }

  // verify that an underline annotation was created between app "closing" and "re-opening"
  func testImportUnderlineAnnotation() {
    let mockData = MockData()
    let pdfViewControllerDelegate = MockPDFViewControllerDelegate(mockPDFViewControllerDelegateDelegate: mockData)
    var pdfViewController: PDFViewController? = PDFViewController.init(documentURL: mockData.documentURL,
                                                                       openToPage: mockData.lastPageRead,
                                                                       bookmarks: mockData.bookmarkPages,
                                                                       annotations: mockData.annotationsData,
                                                                       PSPDFKitLicense: MockAPIKeys.PDFLicenseKey,
                                                                       delegate: pdfViewControllerDelegate)

    XCTAssertFalse((pdfViewController?.document?.containsAnnotations)!, "there should be no annotations")

    // Now, create a new underline annotation
    let annotationPage = 12
    let underlineAnnotation = PSPDFUnderlineAnnotation()

    // Define where you want to place the annotation in the document (required)
    let boundingBox = CGRect(x: 60.316310882568359, y: 355.39178466796875,
                             width: 323.4547119140625, height: 9.752716064453125)
    underlineAnnotation.boundingBox = boundingBox

    // For underline annotations you also need to set the rects array accordingly (required)
    underlineAnnotation.rects = [NSValue(cgRect: boundingBox)]
    // and which page you want the annotation to appear on (required)
    underlineAnnotation.pageIndex = UInt(annotationPage)

    // color and alpha are optional, alpha is opacity
    underlineAnnotation.color = UIColor.black
    underlineAnnotation.alpha = 1.0

    // Add the newly created annotation to the document
    pdfViewController?.document?.add([underlineAnnotation], options: nil)

    pdfViewController = nil
    pdfViewController = PDFViewController.init(documentURL: mockData.documentURL,
                                               openToPage: mockData.lastPageRead,
                                               bookmarks: mockData.bookmarkPages,
                                               annotations: mockData.annotationsData,
                                               PSPDFKitLicense: MockAPIKeys.PDFLicenseKey,
                                               delegate: pdfViewControllerDelegate)

    XCTAssertTrue((pdfViewController?.document?.containsAnnotations)!, "there should an annotation")
    XCTAssertTrue(((pdfViewController?.document?.annotationsForPage(at: UInt(annotationPage),
                                                                    type: PSPDFAnnotationType.underline)) != nil),
                  "should be an annotation on this page")
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
