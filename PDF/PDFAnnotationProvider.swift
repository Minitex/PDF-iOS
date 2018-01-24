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
        print("Error reloading annotation: \(error)")
      }
    }
    super.init(documentProvider: documentProvider)
    self.setAnnotations(annotationArray, append: false)
  }

  // will this disable the save to external file? hope so
  override func saveAnnotations(options: [String : Any]? = nil) throws {
    // do nothing
  }

  override func remove(_ annotations: [PSPDFAnnotation], options: [String : Any]? = nil) -> [PSPDFAnnotation]? {
    // remove the annotation from the internal annotations
    // and then pass the updated annotations list to the host app / delegate
    super.remove(annotations, options: options)

    var jsonData: [Data] = []
    for annotation in self.allAnnotations {
      do {
        jsonData.append(try annotation.generateInstantJSON())
      }
      catch {
        print("Error: Generating InstantJSON !!")
      }
    }

    // pass JSON data off to the host app, or delegate
    pdfModuleDelegate.saveAnnotations(annotationsData: jsonData)

    return annotations
  }

  override func removeAllAnnotations(options: [String : Any] = [:]) {
    super.removeAllAnnotations(options: options)

    // pass JSON data off to the host app, or delegate
    pdfModuleDelegate.saveAnnotations(annotationsData: [])
  }

  override func add(_ annotations: [PSPDFAnnotation], options: [String : Any]? = nil) -> [PSPDFAnnotation]? {
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
        print("Error: Generating InstantJSON !!")
      }
    }
    
    // pass JSON data off to the host app, or delegate
    pdfModuleDelegate.saveAnnotations(annotationsData: jsonData)

    super.add(annotations, options: options)
    return annotations
  }

}
