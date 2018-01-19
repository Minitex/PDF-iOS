//
//  PDFAnnotationProvider.swift
//  PDF
//
//  Created by Vui Nguyen on 1/11/18.
//  Copyright © 2018 Minitex. All rights reserved.
//

import PSPDFKit

class PDFAnnotationProvider: PSPDFContainerAnnotationProvider {

  var pdfModuleDelegate: PDFViewControllerDelegate

  init(annotationsData: Data = Data(), documentProvider: PSPDFDocumentProvider, pdfModuleDelegate: PDFViewControllerDelegate) {
    self.pdfModuleDelegate = pdfModuleDelegate

    var annotation = PSPDFAnnotation()
    do {
      annotation = try PSPDFAnnotation(fromInstantJSON: annotationsData, documentProvider: documentProvider)
    }
    catch {
      print(error)
    }
    super.init(documentProvider: documentProvider)
    self.setAnnotations([annotation], append: true)
  }

  /*
  override func annotationsForPage(at pageIndex: UInt) -> [PSPDFAnnotation]? {

  }
 */

  override func remove(_ annotations: [PSPDFAnnotation], options: [String : Any]? = nil) -> [PSPDFAnnotation]? {
    super.remove(annotations, options: options)
    return annotations
  }

  override func removeAllAnnotations(options: [String : Any] = [:]) {
    super.removeAllAnnotations(options: options)
  }

  override func add(_ annotations: [PSPDFAnnotation], options: [String : Any]? = nil) -> [PSPDFAnnotation]? {
    // convert to JSON and pass it off to the host app

    print("an annotation was added!")

    var jsonData = Data()

    for annotation in annotations {
      print(annotation)
      do {
        //let jsonData: Data = try annotation.generateInstantJSON()
        jsonData.append(try annotation.generateInstantJSON())
        //let jsonDataString = String(data: jsonData, encoding: String.Encoding.utf8)
        //print(jsonDataString ?? "no string value here")
      }
      catch {
        print("Error: Generate InstantJSON!!")
      }
    }

    pdfModuleDelegate.saveAnnotations(annotations: jsonData)
    super.add(annotations, options: options)
    return annotations
  }

}
