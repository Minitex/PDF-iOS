//
//  PDFAnnotationProvider.swift
//  PDF
//
//  Created by Vui Nguyen on 1/11/18.
//  Copyright © 2018 Minitex. All rights reserved.
//

import PSPDFKit

class PDFAnnotationProvider: PSPDFContainerAnnotationProvider {

  weak var pdfModuleDelegate: PDFViewControllerDelegate?

  init(annotationsData: [Data] = [], documentProvider: PSPDFDocumentProvider,
       pdfModuleDelegate: PDFViewControllerDelegate) {
    self.pdfModuleDelegate = pdfModuleDelegate

    // reload annotations into the document
    var annotation = PSPDFAnnotation()
    var annotationArray: [PSPDFAnnotation] = []
    for data in annotationsData {
      do {
        annotation = try PSPDFAnnotation(fromInstantJSON: data, documentProvider: documentProvider)
        annotationArray.append(annotation)
      } catch {
        print("Error reloading annotation: \(error)")
      }
    }
    super.init(documentProvider: documentProvider)
    self.setAnnotations(annotationArray, append: false)
  }

  init(annotationObjects: [PDFAnnotation] = [], documentProvider: PSPDFDocumentProvider,
       pdfModuleDelegate: PDFViewControllerDelegate) {
    self.pdfModuleDelegate = pdfModuleDelegate

    // reload annotations into the document
    var annotation = PSPDFAnnotation()
    var annotationArray: [PSPDFAnnotation] = []
    for annotationObject in annotationObjects {
      do {
        annotation = try PSPDFAnnotation(fromInstantJSON: annotationObject.JSONData!,
                                         documentProvider: documentProvider)
        annotationArray.append(annotation)
      } catch {
        print("Error reloading annotation: \(error)")
      }
    }
    super.init(documentProvider: documentProvider)
    self.setAnnotations(annotationArray, append: false)
  }

  private func saveAnnotationsExternally(annotations: [PSPDFAnnotation]) {
    // generate JSON for the annotations
    var jsonData: [Data] = []
    for annotation in annotations {
      do {
        jsonData.append(try annotation.generateInstantJSON())
      } catch {
        print("Error generating InstantJSON !!")
      }
    }

    // pass JSON data off to the host app, or delegate
    pdfModuleDelegate?.saveAnnotations(annotationsData: jsonData)
  }

  // will this disable the save to external file? hope so
  override func saveAnnotations(options: [String: Any]? = nil) throws {
    // do nothing
  }

  // save off edited annotations
  override func didChange(_ annotation: PSPDFAnnotation, keyPaths: [String], options: [String: Any]? = nil) {
    // Do NOT need to update the annotation within the internal annotations
    // (by calling the super function,this causes the app to crash)
    // pass the updated annotations list to the host app / delegate
    saveAnnotationsExternally(annotations: self.allAnnotations)
  }

  override func remove(_ annotations: [PSPDFAnnotation], options: [String: Any]? = nil) -> [PSPDFAnnotation]? {
    // remove the annotation from the internal annotations
    // and then pass the updated annotations list to the host app / delegate
    super.remove(annotations, options: options)
    saveAnnotationsExternally(annotations: self.allAnnotations)
    return annotations
  }

  override func removeAllAnnotations(options: [String: Any] = [:]) {
    // remove all the annotations
    // and then pass the empty annotations list to the host app / delegate
    super.removeAllAnnotations(options: options)
    saveAnnotationsExternally(annotations: [])
  }

  override func add(_ annotations: [PSPDFAnnotation], options: [String: Any]? = nil) -> [PSPDFAnnotation]? {
    // add newly added annotation to the array of all existing annotations
    // pass the updated annotations list to the host app / delegate
    var allCurrentAnnotations: [PSPDFAnnotation] = self.allAnnotations
    allCurrentAnnotations.append(contentsOf: annotations)
    saveAnnotationsExternally(annotations: allCurrentAnnotations)

    // make PSPDFKit add the annotation to the PDF
    super.add(annotations, options: options)
    return annotations
  }

}
