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

  init(annotationsData: [Data] = [], documentProvider: PSPDFDocumentProvider, pdfModuleDelegate: PDFViewControllerDelegate) {
    self.pdfModuleDelegate = pdfModuleDelegate

    var annotation = PSPDFAnnotation()
    var annotationArray: [PSPDFAnnotation] = []
    for data in annotationsData {
      do {
        annotation = try PSPDFAnnotation(fromInstantJSON: data, documentProvider: documentProvider)
        annotationArray.append(annotation)
      }
      catch {
        print(error)
      }
    }
    super.init(documentProvider: documentProvider)
    self.setAnnotations(annotationArray, append: false)
  }

/*
  override func annotationsForPage(at pageIndex: UInt) -> [PSPDFAnnotation]? {

  }
*/

  // will this disable the external save? doesn't look like it
  override func saveAnnotations(options: [String : Any]? = nil) throws {
    // do nothing
  }

  override func remove(_ annotations: [PSPDFAnnotation], options: [String : Any]? = nil) -> [PSPDFAnnotation]? {
    super.remove(annotations, options: options)
    return annotations
  }

  override func removeAllAnnotations(options: [String : Any] = [:]) {
    super.removeAllAnnotations(options: options)
  }

  override func add(_ annotations: [PSPDFAnnotation], options: [String : Any]? = nil) -> [PSPDFAnnotation]? {
    print("an annotation was added!")

    // add currently added annotation to the array of all existing annotations
    // generate JSON for all the current annotations
    var jsonData: [Data] = []
    var allCurrentAnnotations: [PSPDFAnnotation] = self.allAnnotations
    allCurrentAnnotations.append(contentsOf: annotations)

    for annotation in allCurrentAnnotations {
      do {
        jsonData.append(try annotation.generateInstantJSON())
      }
      catch {
        print("Error: Generate InstantJSON1 !!")
      }
    }
    
    // pass JSON data off to the host app, or delegate
    pdfModuleDelegate.saveAnnotations(annotationsData: jsonData)

    super.add(annotations, options: options)
    return annotations
  }

}
