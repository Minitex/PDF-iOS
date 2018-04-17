//
//  PDFAnnotation.swift
//  PDF
//
//  Created by Vui Nguyen on 3/1/18.
//  Copyright © 2018 Minitex. All rights reserved.
//

import Foundation
import PSPDFKitRendererProvider
//import PSPDFKit

/*
public protocol PDFAnnotationDelegate: class {
  //func buildPDFAnnotation() -> PDFAnnotation
  func buildStuff() -> Int
}
 */


// the items that are marked required are needed to
// recreate an annotation in PSPDFKit later
public class PDFAnnotation: Codable {
  // required
  var bbox: [Double]?
  // optional
  var color: String?
  // optional
  var opacity: Float?
  // required
  var pageIndex: UInt?
  // required
  var rects: [[Double]]?
  // required
  var type: String?
  // optional
  // this value cannot be set from PSPDFKit
  //var v: Int?

  // optional
  public var JSONData: Data?

  public init(JSONData: Data) {
    self.JSONData = JSONData
  }

  public init() {

  }
}
