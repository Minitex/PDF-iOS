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

  /*
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
 */

  init(annotationObjects: [PDFAnnotation] = [], documentProvider: PSPDFDocumentProvider,
       pdfModuleDelegate: PDFViewControllerDelegate) {
    self.pdfModuleDelegate = pdfModuleDelegate
    super.init(documentProvider: documentProvider)

    // reload annotations into the document
    var annotation: PSPDFAnnotation?
    //var annotation = PSPDFAnnotation()
    var annotationArray: [PSPDFAnnotation] = []
    for annotationObject in annotationObjects {
      // the logic is:
      // create an annotation directly using attributes from PDFAnnotation, and if
      // that fails, fall back on using the JSON data, and if that fails,
      // return no annotation
      annotation = buildPSPDFAnnotation(from: annotationObject)
      if annotation != nil {
        annotationArray.append(annotation!)
      } else {
        do {
          annotation = try PSPDFAnnotation(fromInstantJSON: annotationObject.JSONData!,
                                         documentProvider: documentProvider)
          annotationArray.append(annotation!)
        } catch {
          print("Error reloading annotation: \(error)")
        }
      }
    }

    self.setAnnotations(annotationArray, append: false)
  }

  private func buildPSPDFAnnotation(from pdfAnnotation: PDFAnnotation) -> PSPDFAnnotation {
    var pspdfAnnotation: PSPDFAnnotation?

    if (pdfAnnotation.type?.hasSuffix("highlight"))! {
      pspdfAnnotation = PSPDFHighlightAnnotation()
    } else if (pdfAnnotation.type?.hasSuffix("underline"))! {
      pspdfAnnotation = PSPDFUnderlineAnnotation()
    }

    // set the required attributes
    pspdfAnnotation?.boundingBox = createRectFromDouble(doubleArray: pdfAnnotation.bbox!)
    pspdfAnnotation?.pageIndex = pdfAnnotation.pageIndex!

    var NSValues: [NSValue] = []
    for rect in (pdfAnnotation.rects)! {
      NSValues.append(createNSValueFromDouble(doubleArray: rect))
    }
    pspdfAnnotation?.rects = NSValues

    // set the optional attributes, if they exist
    // Note: cannot set type or v in PSPDFAnnotation
    if let color = pdfAnnotation.color {
      pspdfAnnotation?.color = UIColor(named: color)
    }
    if let opacity = pdfAnnotation.opacity {
      pspdfAnnotation?.alpha = CGFloat(floatLiteral: opacity)
    }

    return pspdfAnnotation!
  }

  private func createRectFromDouble(doubleArray: [Double]) -> CGRect {
    let cgRect: CGRect = CGRect(x: doubleArray[0], y: doubleArray[1], width: doubleArray[2], height: doubleArray[3])
    return cgRect
  }

  private func createNSValueFromDouble(doubleArray: [Double]) -> NSValue {
    let rect = createRectFromDouble(doubleArray: doubleArray)
    return NSValue(cgRect: rect)
  }

  // TODO: This method is now deprecated, remove eventually
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

  private func savePDFAnnotationsExternally(annotations: [PSPDFAnnotation]) {
    var pdfAnnotations: [PDFAnnotation] = []
    let decoder = JSONDecoder()

    for annotation in annotations {
      do {
        let jsonData = try annotation.generateInstantJSON()
        let pdfAnnotation: PDFAnnotation = try decoder.decode(PDFAnnotation.self, from: jsonData)
        pdfAnnotation.JSONData = jsonData
        pdfAnnotations.append(pdfAnnotation)
      } catch {
        print("Error generating InstantJSON !!")
      }
    }

    // pass PDFAnnotations off to the host app, or delegate
    pdfModuleDelegate?.saveAnnotations(annotations: pdfAnnotations)
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

    savePDFAnnotationsExternally(annotations: self.allAnnotations)
  }

  override func remove(_ annotations: [PSPDFAnnotation], options: [String: Any]? = nil) -> [PSPDFAnnotation]? {
    // remove the annotation from the internal annotations
    // and then pass the updated annotations list to the host app / delegate
    super.remove(annotations, options: options)

    savePDFAnnotationsExternally(annotations: self.allAnnotations)
    return annotations
  }

  override func removeAllAnnotations(options: [String: Any] = [:]) {
    // remove all the annotations
    // and then pass the empty annotations list to the host app / delegate
    super.removeAllAnnotations(options: options)
    savePDFAnnotationsExternally(annotations: [])
  }

  override func add(_ annotations: [PSPDFAnnotation], options: [String: Any]? = nil) -> [PSPDFAnnotation]? {
    // add newly added annotation to the array of all existing annotations
    // pass the updated annotations list to the host app / delegate
    var allCurrentAnnotations: [PSPDFAnnotation] = self.allAnnotations
    allCurrentAnnotations.append(contentsOf: annotations)
    savePDFAnnotationsExternally(annotations: allCurrentAnnotations)

    // make PSPDFKit add the annotation to the PDF
    super.add(annotations, options: options)
    return annotations
  }

}
