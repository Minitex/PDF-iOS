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

  // verify that a highlight annotation was created between app "closing" and "re-opening"
  func testImportHighlightAnnotation() {
    let mockData = MockData()
    let pdfViewControllerDelegate = MockPDFViewControllerDelegate(mockPDFViewControllerDelegateDelegate: mockData)
    var pdfViewController: PDFViewController? = PDFViewController.init(documentURL: mockData.documentURL,
                                                                       openToPage: mockData.lastPageRead,
                                                                       bookmarks: mockData.bookmarkPages,
                                                                       annotations: mockData.annotations,
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
                                               annotations: mockData.annotations,
                                               PSPDFKitLicense: MockAPIKeys.PDFLicenseKey,
                                               delegate: pdfViewControllerDelegate)

    XCTAssertTrue((pdfViewController?.document?.containsAnnotations)!, "there should an annotation")
    XCTAssertTrue(((pdfViewController?.document?.annotationsForPage(at: UInt(annotationPage),
                                                                    type: PSPDFAnnotationType.highlight))! != []),
                  "should be an annotation on this page")
  }

  func testImportUnderlineAnnotation() {
    let mockData = MockData()
    let pdfViewControllerDelegate = MockPDFViewControllerDelegate(mockPDFViewControllerDelegateDelegate: mockData)
    var pdfViewController: PDFViewController? = PDFViewController.init(documentURL: mockData.documentURL,
                                                                       openToPage: mockData.lastPageRead,
                                                                       bookmarks: mockData.bookmarkPages,
                                                                       annotations: mockData.annotations,
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
                                               annotations: mockData.annotations,
                                               PSPDFKitLicense: MockAPIKeys.PDFLicenseKey,
                                               delegate: pdfViewControllerDelegate)

    XCTAssertTrue((pdfViewController?.document?.containsAnnotations)!, "there should an annotation")
    XCTAssertTrue(((pdfViewController?.document?.annotationsForPage(at: UInt(annotationPage),
                                                                    type: PSPDFAnnotationType.underline))! != []),
                  "should be an annotation on this page")
  }

  func testForJSONEquivalence() {
    // recreate annotation based on PDFAnnotation attributes
    // rectrieve the annotation back from the page through a PSPDFKitAnnotation object
    // convert that to JSON
    // compare that JSON to the JSON from the PDFAnnotation class
    let mockData = MockData()
    let pdfViewControllerDelegate = MockPDFViewControllerDelegate(mockPDFViewControllerDelegateDelegate: mockData)
    var pdfViewController: PDFViewController? = PDFViewController.init(documentURL: mockData.documentURL,
                                                                       openToPage: mockData.lastPageRead,
                                                                       bookmarks: mockData.bookmarkPages,
                                                                       annotations: mockData.annotations,
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

    // grab the JSON before we persist it?
    // I need to be able to grab the PSPDFAnnotation from this page, and get its JSON
    var pspdfAnnotation: [PSPDFAnnotation] = (pdfViewController?.document?.annotationsForPage(at: UInt(annotationPage),
                                                                                type: PSPDFAnnotationType.underline))!
    var pspdfAnnotationJSON: Data = Data()

    do {
      try pspdfAnnotationJSON = pspdfAnnotation[0].generateInstantJSON()
    } catch {
      print("cannot get the instant JSON")
    }

    // swiftlint:disable line_length
    print("Right after ADDING, pspdfAnnotationJSON is: \(String(data: pspdfAnnotationJSON, encoding: String.Encoding.utf8) ?? "no JSON value here")")

    pdfViewController = nil
    pdfViewController = PDFViewController.init(documentURL: mockData.documentURL,
                                               openToPage: mockData.lastPageRead,
                                               bookmarks: mockData.bookmarkPages,
                                               annotations: mockData.annotations,
                                               PSPDFKitLicense: MockAPIKeys.PDFLicenseKey,
                                               delegate: pdfViewControllerDelegate)

    // I need to be able to grab the PSPDFAnnotation from this page, and get its JSON
    pspdfAnnotation = (pdfViewController?.document?.annotationsForPage(at: UInt(annotationPage),
                                                                      type: PSPDFAnnotationType.underline))!

    do {
      try pspdfAnnotationJSON = pspdfAnnotation[0].generateInstantJSON()
    } catch {
      print("cannot get the instant JSON")
    }

    print("Right after RE-LOADING, pspdfAnnotationJSON is: \(String(data: pspdfAnnotationJSON, encoding: String.Encoding.utf8) ?? "no JSON value here")")
    print("mockData AnnotationJSON is: \(String(data: mockData.annotations[0].JSONData!, encoding: String.Encoding.utf8) ?? "no JSON value here")")

    XCTAssertTrue((pdfViewController?.document?.containsAnnotations)!, "there should an annotation")
    XCTAssertTrue(((pdfViewController?.document?.annotationsForPage(at: UInt(annotationPage),
                                                                    type: PSPDFAnnotationType.underline))! != []),
                  "should be an annotation on this page")
    XCTAssert(pspdfAnnotationJSON == mockData.annotations[0].JSONData, "the JSON should be the same")
  }

  // creating a new dictionary in this way does NOT work!
  func testDictionaryAnnotationReloading() {
    // recreate annotation based on PDFAnnotation attributes
    // rectrieve the annotation back from the page through a PSPDFKitAnnotation object
    // convert that to JSON
    // compare that JSON to the JSON from the PDFAnnotation class
    let mockData = MockData()
    let pdfViewControllerDelegate = MockPDFViewControllerDelegate(mockPDFViewControllerDelegateDelegate: mockData)
    var pdfViewController: PDFViewController? = PDFViewController.init(documentURL: mockData.documentURL,
                                                                       openToPage: mockData.lastPageRead,
                                                                       bookmarks: mockData.bookmarkPages,
                                                                       annotations: mockData.annotations,
                                                                       PSPDFKitLicense: MockAPIKeys.PDFLicenseKey,
                                                                       delegate: pdfViewControllerDelegate)

    XCTAssertFalse((pdfViewController?.document?.containsAnnotations)!, "there should be no annotations")

    // Now, create a new underline annotation
    let annotationPage = 12
    //let underlineAnnotation = PSPDFUnderlineAnnotation()
    
    let typeString: PSPDFAnnotationString = PSPDFAnnotationString.underline
    // Define where you want to place the annotation in the document (required)
    let boundingBox = CGRect(x: 60.316310882568359, y: 355.39178466796875,
                             width: 323.4547119140625, height: 9.752716064453125)
    //underlineAnnotation.boundingBox = boundingBox

    // For underline annotations you also need to set the rects array accordingly (required)
    let rects = [NSValue(cgRect: boundingBox)]
    // and which page you want the annotation to appear on (required)
    let pageIndex = UInt(annotationPage)

    // color and alpha are optional, alpha is opacity
    let color = UIColor.black
    let alpha = 1.0

    // Add the newly created annotation to the document
    /*
    let dictionary: [String: Any] = ["pageIndex": pageIndex, "typeString": typeString, "rects": rects, "boundingBox": boundingBox,
                                     "color": color, "alpha": alpha]
 */
    let dictionary: [String: Any] = ["pageIndex": pageIndex, "rects": rects, "boundingBox": boundingBox,
                                   "color": color, "alpha": alpha]
    var underlineAnnotation: PSPDFAnnotation?
    do {
      underlineAnnotation = try PSPDFUnderlineAnnotation(dictionary: dictionary)
    } catch {
      print("unable to create underline annotation")
    }
    pdfViewController?.document?.add([underlineAnnotation!], options: nil)

    // grab the JSON before we persist it?
    // I need to be able to grab the PSPDFAnnotation from this page, and get its JSON
    var pspdfAnnotation: [PSPDFAnnotation] = (pdfViewController?.document?.annotationsForPage(at: UInt(pageIndex),
                                                                                              type: PSPDFAnnotationType.underline))!
    var pspdfAnnotationJSON: Data = Data()

    do {
      try pspdfAnnotationJSON = pspdfAnnotation[0].generateInstantJSON()
    } catch {
      print("cannot get the instant JSON")
    }

    // swiftlint:disable line_length
    print("Right after ADDING, pspdfAnnotationJSON is: \(String(data: pspdfAnnotationJSON, encoding: String.Encoding.utf8) ?? "no JSON value here")")

    pdfViewController = nil
    pdfViewController = PDFViewController.init(documentURL: mockData.documentURL,
                                               openToPage: mockData.lastPageRead,
                                               bookmarks: mockData.bookmarkPages,
                                               annotations: mockData.annotations,
                                               PSPDFKitLicense: MockAPIKeys.PDFLicenseKey,
                                               delegate: pdfViewControllerDelegate)

    // I need to be able to grab the PSPDFAnnotation from this page, and get its JSON
    pspdfAnnotation = (pdfViewController?.document?.annotationsForPage(at: UInt(pageIndex),
                                                                       type: PSPDFAnnotationType.underline))!

    do {
      try pspdfAnnotationJSON = pspdfAnnotation[0].generateInstantJSON()
    } catch {
      print("cannot get the instant JSON")
    }

    print("Right after RE-LOADING, pspdfAnnotationJSON is: \(String(data: pspdfAnnotationJSON, encoding: String.Encoding.utf8) ?? "no JSON value here")")
    print("mockData AnnotationJSON is: \(String(data: mockData.annotations[0].JSONData!, encoding: String.Encoding.utf8) ?? "no JSON value here")")

    XCTAssertTrue((pdfViewController?.document?.containsAnnotations)!, "there should an annotation")
    XCTAssertTrue(((pdfViewController?.document?.annotationsForPage(at: UInt(pageIndex),
                                                                    type: PSPDFAnnotationType.underline))! != []),
                  "should be an annotation on this page")
    XCTAssert(pspdfAnnotationJSON == mockData.annotations[0].JSONData, "the JSON should be the same")

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
