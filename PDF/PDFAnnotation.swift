//
//  PDFAnnotation.swift
//  PDF
//
//  Created by Vui Nguyen on 3/1/18.
//  Copyright © 2018 Minitex. All rights reserved.
//

import Foundation
import PSPDFKit

public protocol PSPDFAnnotationDelegate: class {

  var pspdfAnnotation: PSPDFAnnotation { get }
}

public class PDFAnnotation: Codable {
  // required
  var bbox: [Float]?
  var color: String?
  var opacity: Float?
  var pageIndex: Int?
  var rects: [[Float]]?
  var type: String?
  var v: Int?

  var JSONData: Data?

  init(JSONData: Data) {
    self.JSONData = JSONData
  }

  init() {

  }
}

// without using JSONData, recreate a PSPDFAnnotation
// we must convert [Float] to [CGRect] and [[Float]] to [[CGRect]]
// manually because CGRect is NOT a Codable type
extension PDFAnnotation: PSPDFAnnotationDelegate {
  // convert stuff
  public var pspdfAnnotation: PSPDFAnnotation {
      var annotation = PSPDFAnnotation()

      // check what type of annotation we have
      /*
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

      enum AnnotationType: String {
        case highlight
        case underline
      }

      var pageIndex: UInt?
      // required
      var type: AnnotationType?
      // required
      var bbox: CGRect?
      // required
      var rects: [CGRect]?
      // required

      // optional
      var color: UIColor?
      var opacity: Float?
 */
      return annotation
  }
}
