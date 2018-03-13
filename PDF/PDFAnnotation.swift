//
//  PDFAnnotation.swift
//  PDF
//
//  Created by Vui Nguyen on 3/1/18.
//  Copyright © 2018 Minitex. All rights reserved.
//

import Foundation
import PSPDFKit

// the items that are marked required are needed to
// recreate an annotation in PSPDFKit later
public class PDFAnnotation: Codable {
  // required
  var bbox: [Double]?
  // optional
  var color: String?
  // optional
  var opacity: Double?
  // required
  var pageIndex: UInt?
  // required
  var rects: [[Double]]?
  // required
  var type: String?
  // optional
  var v: Int?

  // optional
  var JSONData: Data?

  init(JSONData: Data) {
    self.JSONData = JSONData
  }

  init() {

  }
}
