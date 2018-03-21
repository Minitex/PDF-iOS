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

    // reload annotations into the document
    var annotation: PSPDFAnnotation?
    var annotationArray: [PSPDFAnnotation] = []
    for annotationObject in annotationObjects {
      // the logic is:
      // create an annotation directly using attributes from PDFAnnotation, and if
      // that fails, fall back on using the JSON data, and if that fails,
      // return no annotation
      //         Paul: the lines below parses PDFAnnotation -> PSPDFAnnnotation
      //         but they are currently commented out so we are now parsing
      //         JSON -> PSPDFAnnotation like before
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
    super.init(documentProvider: documentProvider)
    self.setAnnotations(annotationArray, append: false)
    //self.setAnnotationCacheDirect([NSNumber(annotationArray.count): annotationArray])
    //self.setAnnotationCacheDirect(annotationCache as! [NSNumber: [PSPDFAnnotation]])
  }

  private static func buildPSPDFAnnotation(from pdfAnnotation: PDFAnnotation) -> PSPDFAnnotation {
    var pspdfAnnotation: PSPDFAnnotation?

    /*
    if (pdfAnnotation.type?.hasSuffix("highlight"))! {
      pspdfAnnotation = PSPDFHighlightAnnotation()
    } else if (pdfAnnotation.type?.hasSuffix("underline"))! {
      pspdfAnnotation = PSPDFUnderlineAnnotation()
    }
 */

    if (pdfAnnotation.type?.lowercased().hasSuffix("highlight"))! {
      pspdfAnnotation = PSPDFHighlightAnnotation()
    } else if (pdfAnnotation.type?.lowercased().hasSuffix("underline"))! {
      pspdfAnnotation = PSPDFUnderlineAnnotation()
      pspdfAnnotation?.color = .red
    }


    // set the required attributes
    pspdfAnnotation?.boundingBox = createRectFromDouble(doubleArray: pdfAnnotation.bbox!)
    pspdfAnnotation?.pageIndex = pdfAnnotation.pageIndex!

    // here are we parsing the PDFAnnotation rects array -> PSPDFAnnotation rects array
    // but it doesn't seem to be working
    var NSValues: [NSValue] = []
    for rect in (pdfAnnotation.rects)! {
      NSValues.append(createNSValueFromDouble(doubleArray: rect))
    }
    pspdfAnnotation?.rects = NSValues

    // here were are setting the PSPDFAnnotation rects to the same value as its
    // bounding box, but this doesn't seem to work very well either
    // look at this: https://pspdfkit.com/guides/ios/current/annotations/programmatically-creating-annotations/
    //pspdfAnnotation?.rects = [NSValue(cgRect: (pspdfAnnotation?.boundingBox)!)]

    // set the optional attributes, if they exist
    // Note: cannot set type or v in PSPDFAnnotation
    // for now, we're letting the default color get set
    // to rule out the possibility that parsing the color is part of the problem
    // with reloading annotations

    if let color = pdfAnnotation.color {
      pspdfAnnotation?.color = UIColor(hexaDecimalString: pdfAnnotation.color!)
      //pspdfAnnotation?.color = hexStringToUIColor(hex: color)
      //let colorValues = color.components(separatedBy: " ")
      //pspdfAnnotation?.color = UIColor(red:
       // colorValues[1].CGFloatValue()!, green: colorValues[2].CGFloatValue()!,
       //                                blue: colorValues[3].CGFloatValue()!, alpha: colorValues[4].CGFloatValue()!)
     // pspdfAnnotation?.color = UIColor(red: CGFloat(colorValues[1]),
      //                                 green: CGFloat(colorValues[2]),
      //                                                blue: CGFloat(colorValues[3]),
       //
      /*alpha: CGFloat(colorValues[4]) )
      pspdfAnnotation?.color = UIColor(red: CGFloat((colorValues[1] as NSString).floatValue),
                                                    green: CGFloat((colorValues[2] as NSString).floatValue),
                                                    blue: CGFloat((colorValues[3] as NSString).floatValue),
                                                    alpha: CGFloat((colorValues[4] as NSString).floatValue))
 */
//if pspdfAnnotation is PSPDFUnderlineAnnotation {
   //     pspdfAnnotation?.color = UIColor.green
   //   } else {
     // pspdfAnnotation?.color = UIColor(rgbaString: color)
  //    }
    //  print(pspdfAnnotation?.color ?? "no color here")

   }

/*
    if let opacity = pdfAnnotation.opacity {
      pspdfAnnotation?.alpha = CGFloat(floatLiteral: CGFloat.NativeType(opacity))
    }
*/

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

  // So, fun fact:
  // We can build a CGRect only from a Double or a CGFloat array, it cannot be done from a Float array
  // that's why I was playing around with these data types specifically
  /*
  private func createRectFromFloat(floatArray: [CGFloat]) -> CGRect {
    let cgRect: CGRect = CGRect(x: floatArray[0], y: floatArray[1], width: floatArray[2], height: floatArray[3])
    return cgRect
  }
 */

  private static func createRectFromDouble(doubleArray: [Double]) -> CGRect {
    let cgRect: CGRect = CGRect(x: doubleArray[0], y: doubleArray[1], width: doubleArray[2], height: doubleArray[3])
    //let cgRect: CGRect = CGRect(origin: CGPoint(x: doubleArray[0], y: doubleArray[1]),
    //                            size: CGSize(width: doubleArray[2], height: doubleArray[3]))
    return cgRect
  }

  /*
  private func createNSValueFromFloat(floatArray: [CGFloat]) -> NSValue {
    let rect = createRectFromFloat(floatArray: floatArray)
    return NSValue(cgRect: rect)
  }
 */

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

  private func savePDFAnnotationsExternally(annotations: [PSPDFAnnotation]) {
    var pdfAnnotations: [PDFAnnotation] = []
    //let decoder = JSONDecoder()

    for annotation in annotations {
      /*
      do {
        let jsonData = try annotation.generateInstantJSON()
        let pdfAnnotation: PDFAnnotation = try decoder.decode(PDFAnnotation.self, from: jsonData)
        pdfAnnotation.JSONData = jsonData
 */
        let pdfAnnotation: PDFAnnotation = buildPDFAnnotation(from: annotation)
        pdfAnnotations.append(pdfAnnotation)
      /*
      } catch {
        print("Error generating InstantJSON !!")
      }
 */
    }

    // pass PDFAnnotations off to the host app, or delegate
    pdfModuleDelegate?.saveAnnotations(annotations: pdfAnnotations)
  }

  private func buildPDFAnnotation(from pspdfAnnotation: PSPDFAnnotation) -> PDFAnnotation {
    var pdfAnnotation: PDFAnnotation?
    do {
      try pdfAnnotation = PDFAnnotation(JSONData: pspdfAnnotation.generateInstantJSON())
      pdfAnnotation?.bbox = createDoubleFromRect(cgRect: pspdfAnnotation.boundingBox)
      // color
      //print(pdfAnnotation?.color ?? "no color")
      //pdfAnnotation?.color = String(describing: pspdfAnnotation.color)
      pdfAnnotation?.color = pspdfAnnotation.color?.toHexString()
      pdfAnnotation?.opacity = Float(pspdfAnnotation.alpha)
      pdfAnnotation?.pageIndex = pspdfAnnotation.pageIndex
      pdfAnnotation?.rects = []
      for rect in pspdfAnnotation.rects! {
        pdfAnnotation?.rects?.append(createDoubleFromNSValue(nsValue: rect))
      }
      pdfAnnotation?.type = pspdfAnnotation.typeString.rawValue
    } catch {
      print("Error generating InstantJSON !!")
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

extension UIColor {
  //Convert RGBA String to UIColor object
  //"rgbaString" must be separated by space "0.5 0.6 0.7 1.0" 50% of Red 60% of Green 70% of Blue Alpha 100%
  public convenience init?(rgbaString: String) {
    self.init(ciColor: CIColor(string: rgbaString))
  }

  //Convert UIColor to RGBA String
  func toRGBAString() -> String {

    var r: CGFloat = 0
    var g: CGFloat = 0
    var b: CGFloat = 0
    var a: CGFloat = 0
    self.getRed(&r, green: &g, blue: &b, alpha: &a)
    return "\(r) \(g) \(b) \(a)"

  }
  //return UIColor from Hexadecimal Color string
  public convenience init?(hexaDecimalString: String) {

    let r, g, b, a: CGFloat

    if hexaDecimalString.hasPrefix("#") {
      let start = hexaDecimalString.index(hexaDecimalString.startIndex, offsetBy: 1)
      //let hexColor = hexaDecimalString.substring(from: start)
      let hexColor = String(hexaDecimalString.suffix(from: start))

      //if hexColor.count == 8 {
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0

        if scanner.scanHexInt64(&hexNumber) {
          r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
          g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
          b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
          a = CGFloat(hexNumber & 0x000000ff) / 255
          //a = 1.0
          self.init(red: r, green: g, blue: b, alpha: a)
          return
        }
     // }
    }

    return nil
  }
  // Convert UIColor to Hexadecimal String
  func toHexString() -> String {
    var r: CGFloat = 0
    var g: CGFloat = 0
    var b: CGFloat = 0
    var a: CGFloat = 1
    self.getRed(&r, green: &g, blue: &b, alpha: &a)
    return String(
      format: "%02X%02X%02X",
      Int(r * 0xff),
      Int(g * 0xff),
      Int(b * 0xff)
    )
  }
}

extension String {

  func CGFloatValue() -> CGFloat? {
    if let n = NumberFormatter().number(from: self) {
      let f = CGFloat(truncating: n)
      return f
    }
    return CGFloat(0.0)
  }
}

extension CGFloat {
  init?(string: String) {
    guard let number = NumberFormatter().number(from: string) else {
      return nil
    }
    self.init(number.floatValue)
  }
}
