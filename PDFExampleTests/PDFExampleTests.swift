//
//  PDFExampleTests.swift
//  PDFExampleTests
//
//  Created by Vui Nguyen on 11/14/17.
//  Copyright © 2017 Minitex. All rights reserved.
//

import XCTest
@testable import PDFExample

class PDFExampleTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    func testExample() {
      let bundle = Bundle(identifier: "edu.umn.minitex.simplye.pdfexample")
      let sb = UIStoryboard(name: "PDFExample", bundle: bundle)
      let pdfExampleController = sb.instantiateViewController(withIdentifier: "PDFExample") as! ViewController
      XCTAssertNotNil(pdfExampleController, "example view controller doesn't exist")

      let book: Book = pdfExampleController.books![0]
      let documentName = book.title
      pdfExampleController.currentBook = documentName
      let fileURL = Bundle.main.url(forResource: documentName, withExtension: "pdf")!
      /*
      let pdfViewController = PDFViewController.init(documentURL: fileURL, openToPage: book.lastPageRead,
                                                     bookmarks: book.bookmarks, annotations: book.PDFAnnotations,
                                                     PSPDFKitLicense: APIKeys.PDFLicenseKey,
                                                     delegate: pdfExampleController)
      XCTAssertNotNil(pdfViewController, "pdf view controller doesn't exist")
 */

      let pdfRendererController = PDFRendererProvider.init(documentURL: fileURL, openToPage: book.lastPageRead,
                                                           bookmarks: book.bookmarks,
                                                           annotations: book.PDFAnnotations,
                                                           PSPDFKitLicense: APIKeys.PDFLicenseKey,
                                                        delegate: pdfExampleController)
      XCTAssertNotNil(pdfRendererController, "pdf renderer controller doesn't exist")
  }
}
