//
//  PDFAnnotationProvider.swift
//  PDF
//
//  Created by Vui Nguyen on 1/11/18.
//  Copyright © 2018 Minitex. All rights reserved.
//

import PSPDFKit
import MinitexPDFProtocols

class PDFAnnotationProvider: PSPDFContainerAnnotationProvider {

  //weak var pdfModuleDelegate: PDFViewControllerDelegate?
  weak var pdfModuleDelegate: MinitexPDFViewControllerDelegate?

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

  init(annotationObjects: [MinitexPDFAnnotation] = [], documentProvider: PSPDFDocumentProvider,
       //pdfModuleDelegate: PDFViewControllerDelegate) {
       pdfModuleDelegate: MinitexPDFViewControllerDelegate) {
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
        print("PDFAnnotationProvider: rebuild from MinitexPDFAnnotation")
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

  private static func buildPSPDFAnnotation(from pdfAnnotation: MinitexPDFAnnotation) -> PSPDFAnnotation {
    var pspdfAnnotation: PSPDFAnnotation?

    if (pdfAnnotation.type?.lowercased().hasSuffix("highlight"))! {
      pspdfAnnotation = PSPDFHighlightAnnotation()
    } else if (pdfAnnotation.type?.lowercased().hasSuffix("underline"))! {
      pspdfAnnotation = PSPDFUnderlineAnnotation()
    } else {
      return pspdfAnnotation!
    }

    // set the required attributes
    pspdfAnnotation?.boundingBox = CGRectFromString(pdfAnnotation.bbox!)
    pspdfAnnotation?.pageIndex = pdfAnnotation.pageIndex!
    pspdfAnnotation?.rects = createNSValueArrayFromStringArray(stringValues: pdfAnnotation.rects!)

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

  private static func createStringArrayFromNSValueArray(nsValues: [NSValue]) -> [String] {
    var stringArray: [String] = []
    stringArray = nsValues.map { (nsValue: NSValue) -> String in
      return NSStringFromCGRect(nsValue.cgRectValue)
    }
    return stringArray
  }

  private static func createNSValueArrayFromStringArray(stringValues: [String]) -> [NSValue] {
    var nsArray: [NSValue] = []
    nsArray = stringValues.map { (stringValue: String) -> NSValue in
      return NSValue.init(cgRect: CGRectFromString(stringValue))
    }
    return nsArray
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

  private func savePDFAnnotationsExternally(annotations: [PSPDFAnnotation]) {
    var pdfAnnotations: [MinitexPDFAnnotation] = []
    //let decoder = JSONDecoder()

    for annotation in annotations {
      let pdfAnnotation: MinitexPDFAnnotation = buildMinitexPDFAnnotation(from: annotation)!
      pdfAnnotations.append(pdfAnnotation)
    }

    // pass PDFAnnotations off to the host app, or delegate
    pdfModuleDelegate?.saveAnnotations(annotations: pdfAnnotations)
  }

  private func buildMinitexPDFAnnotation(from pspdfAnnotation: PSPDFAnnotation) -> MinitexPDFAnnotation? {
    let pageIndex = pspdfAnnotation.pageIndex
    let type = pspdfAnnotation.typeString.rawValue
    let bbox = NSStringFromCGRect(pspdfAnnotation.boundingBox)
    let rects = PDFAnnotationProvider.createStringArrayFromNSValueArray(nsValues: pspdfAnnotation.rects!)
    let color = PDFAnnotationProvider.UIColorToHexString(uicolor: pspdfAnnotation.color!)
    let opacity = Float(pspdfAnnotation.alpha)
    var pdfAnnotation: MinitexPDFAnnotation?
    var JSONData: Data?
    do {
      JSONData = try pspdfAnnotation.generateInstantJSON()

    } catch {
      print("Error building PDFAnnotations!")
    }

    pdfAnnotation = MinitexPDFAnnotation(pageIndex: pageIndex, type: type, bbox: bbox, rects: rects,
                                         color: color, opacity: opacity, JSONData: JSONData)
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
