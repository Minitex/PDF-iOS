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
  weak var pdfRendererDelegate: PDFRendererProviderDelegate?

  // The function below is now deprecated, but we're not ready to remove it yet
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
    var annotationArray: [PSPDFAnnotation] = []
    for annotationObject in annotationObjects {
      // the logic is:
      // create an annotation directly using attributes from PDFAnnotation, and if
      // that fails, fall back on using the JSON data, and if that fails,
      // return no annotation
      annotation = PDFAnnotationProvider.buildPSPDFAnnotation(from: annotationObject)
      if annotation != nil {
        annotationArray.append(annotation!)
        print("PDFAnnotationProvider: rebuild from PDFAnnotation")
      } else {
        do {
          annotation = try PSPDFAnnotation(fromInstantJSON: annotationObject.JSONData!,
                                         documentProvider: documentProvider)
          annotationArray.append(annotation!)
          print("PDFAnnotationProvider: rebuild from JSON")
        } catch {
          print("Error reloading annotation: \(error)")
        }
      }
    }

    self.setAnnotations(annotationArray, append: false)
  }

  init(annotationObjects: [PDFAnnotation] = [], documentProvider: PSPDFDocumentProvider,
       pdfRendererDelegate: PDFRendererProviderDelegate) {
    self.pdfRendererDelegate = pdfRendererDelegate
    super.init(documentProvider: documentProvider)
    // reload annotations into the document
    var annotation: PSPDFAnnotation?
    var annotationArray: [PSPDFAnnotation] = []
    for annotationObject in annotationObjects {
      // the logic is:
      // create an annotation directly using attributes from PDFAnnotation, and if
      // that fails, fall back on using the JSON data, and if that fails,
      // return no annotation
      annotation = PDFAnnotationProvider.buildPSPDFAnnotation(from: annotationObject)
      if annotation != nil {
        annotationArray.append(annotation!)
        print("PDFAnnotationProvider: rebuild from PDFAnnotation")
      } else {
        do {
          annotation = try PSPDFAnnotation(fromInstantJSON: annotationObject.JSONData!,
                                           documentProvider: documentProvider)
          annotationArray.append(annotation!)
          print("PDFAnnotationProvider: rebuild from JSON")
        } catch {
          print("Error reloading annotation: \(error)")
        }
      }
    }

    self.setAnnotations(annotationArray, append: false)
  }

  private static func buildPSPDFAnnotation(from pdfAnnotation: PDFAnnotation) -> PSPDFAnnotation {
    var pspdfAnnotation: PSPDFAnnotation?

    if (pdfAnnotation.type?.lowercased().hasSuffix("highlight"))! {
      pspdfAnnotation = PSPDFHighlightAnnotation()
    } else if (pdfAnnotation.type?.lowercased().hasSuffix("underline"))! {
      pspdfAnnotation = PSPDFUnderlineAnnotation()
    } else {
      return pspdfAnnotation!
    }

    // set the required attributes
    pspdfAnnotation?.boundingBox = createRectFromDouble(doubleArray: pdfAnnotation.bbox!)
    pspdfAnnotation?.pageIndex = pdfAnnotation.pageIndex!

    var NSValues: [NSValue] = []
    for rect in (pdfAnnotation.rects)! {
      NSValues.append(createNSValueFromDouble(doubleArray: rect))
    }
    pspdfAnnotation?.rects = NSValues

    // since color and opacity are optional attributes, we will set them only if they exist
    if let color = pdfAnnotation.color {
      pspdfAnnotation?.color = hexStringToUIColor(hex: color)
    }

    if let opacity = pdfAnnotation.opacity {
      pspdfAnnotation?.alpha = CGFloat(floatLiteral: CGFloat.NativeType(opacity))
    }

    return pspdfAnnotation!
  }

  private static func hexStringToUIColor (hex: String) -> UIColor {
    var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if cString.hasPrefix("#") {
      cString.remove(at: cString.startIndex)
    }

    if cString.count != 6 {
      return UIColor.gray
    }

    var rgbValue: UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)

    return UIColor(
      red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
      alpha: CGFloat(1.0)
    )
  }

  private static func UIColorToHexString (uicolor: UIColor) -> String {
    var r: CGFloat = 0
    var g: CGFloat = 0
    var b: CGFloat = 0
    var a: CGFloat = 1
    uicolor.getRed(&r, green: &g, blue: &b, alpha: &a)
    return String(
      format: "%02X%02X%02X",
      Int(r * 0xff),
      Int(g * 0xff),
      Int(b * 0xff)
    )
  }

  // Fun fact:
  // We can build a CGRect only from a Double or a CGFloat array, it cannot be done from a Float array
  // We're going with Double because that's what's defined in PDFAnnotation
  // class for the rect and boundingBox attributes
  private static func createRectFromDouble(doubleArray: [Double]) -> CGRect {
    let cgRect: CGRect = CGRect(x: doubleArray[0], y: doubleArray[1], width: doubleArray[2], height: doubleArray[3])
    return cgRect
  }

  private static func createNSValueFromDouble(doubleArray: [Double]) -> NSValue {
    let rect = createRectFromDouble(doubleArray: doubleArray)
    return NSValue(cgRect: rect)
  }

  private func createDoubleFromRect(cgRect: CGRect) -> [Double] {
    var doubleArray: [Double] = [0, 0, 0, 0]
    doubleArray[0] = Double(cgRect.origin.x)
    doubleArray[1] = Double(cgRect.origin.y)
    doubleArray[2] = Double(cgRect.width)
    doubleArray[3] = Double(cgRect.height)
    return doubleArray
  }

  private func createDoubleFromNSValue(nsValue: NSValue) -> [Double] {
    let cgRect = nsValue.cgRectValue
    return createDoubleFromRect(cgRect: cgRect)
  }

  // This method is now deprecated, remove eventually
  /*
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
 */

  /*
  private func savePDFAnnotationsExternally(annotations: [PSPDFAnnotation]) {
    var pdfAnnotations: [PDFAnnotation] = []
    //let decoder = JSONDecoder()

    for annotation in annotations {
      let pdfAnnotation: PDFAnnotation = buildPDFAnnotation(from: annotation)
      pdfAnnotations.append(pdfAnnotation)
    }

    // pass PDFAnnotations off to the host app, or delegate
    pdfModuleDelegate?.saveAnnotations(annotations: pdfAnnotations)
  }
 */

  private func savePDFAnnotationsExternally(annotations: [PSPDFAnnotation]) {
    var pdfAnnotations: [PDFAnnotation] = []
    //let decoder = JSONDecoder()

    for annotation in annotations {
      let pdfAnnotation: PDFAnnotation = buildPDFAnnotation(from: annotation)
      pdfAnnotations.append(pdfAnnotation)
    }

    // pass PDFAnnotations off to the host app, or delegate
    pdfRendererDelegate?.saveAnnotations(annotations: pdfAnnotations)
  }

  private func buildPDFAnnotation(from pspdfAnnotation: PSPDFAnnotation) -> PDFAnnotation {
    var pdfAnnotation: PDFAnnotation?
    do {
      try pdfAnnotation = PDFAnnotation(JSONData: pspdfAnnotation.generateInstantJSON())
      pdfAnnotation?.bbox = createDoubleFromRect(cgRect: pspdfAnnotation.boundingBox)
      pdfAnnotation?.color = PDFAnnotationProvider.UIColorToHexString(uicolor: pspdfAnnotation.color!)
      pdfAnnotation?.opacity = Float(pspdfAnnotation.alpha)
      pdfAnnotation?.pageIndex = pspdfAnnotation.pageIndex
      pdfAnnotation?.rects = []
      for rect in pspdfAnnotation.rects! {
        pdfAnnotation?.rects?.append(createDoubleFromNSValue(nsValue: rect))
      }
      pdfAnnotation?.type = pspdfAnnotation.typeString.rawValue
    } catch {
      print("Error building PDFAnnotation !!")
    }
    return pdfAnnotation!
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
