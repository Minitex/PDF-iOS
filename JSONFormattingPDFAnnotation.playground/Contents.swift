//: Playground - noun: a place where people can play
// This playground demonstrates:
// parsing PSPDFAnnotation data (in JSON Data blob) into a PDFAnnotation object
// parsing PDF Annotation object into a dictionary
// and then going back in the other direction
// So: PSPDFAnnotation JSON data -> PDFAnnotation -> dictionary
// Dictionary -> PDFAnnotation -> PSPDFAnnotation

import Foundation
import UIKit

let json = """
{
  "bbox": [57.174537658691406, 320.7777099609375, 323.847412109375, 23.301727294921875],
  "color": "#FCED8C",
  "opacity": 1,
  "pageIndex": 11,
  "rects": [[56.199268341064453, 319.80242919921875, 325.79794311523438, 11.7032470703125],
            [381.0001220703125, 328.174072265625, 0, 0],
            [56.297451019287109, 333.3514404296875, 168.49978637695312, 11.7032470703125]],
  "type": "pspdfkit/markup/highlight", "v": 1
}
""".data(using: .utf8)!

// this is the format we expect to get from PSPDFKit
class PDFAnnotation: Codable {
  var bbox: [Double]?
  var color: String?
  var opacity: Float?
  var pageIndex: Int?
  var rects: [[Double]]?
  var type: String?
  var v: Int?

  // original JSON data
  var JSONData: Data?
}

print("hi")
let decoder = JSONDecoder()
var pdfAnnotation = try decoder.decode(PDFAnnotation.self, from: json)
pdfAnnotation.JSONData = json
//print(pdfAnnotation.bbox ?? "")
//print(pdfAnnotation.color ?? "")
//print(pdfAnnotation.rects ?? "")
//print(pdfAnnotation.opacity!)
print("JSON Data is: ")
print(String(data: pdfAnnotation.JSONData!, encoding: String.Encoding.utf8) ?? "")

//print(String(describing: pdfAnnotation.bbox))
//print(String(describing: pdfAnnotation.rects))

func createRectFromDouble(doubleArray: [Double]) -> CGRect {
  let cgRect: CGRect = CGRect(x: doubleArray[0], y: doubleArray[1], width: doubleArray[2], height: doubleArray[3])
  return cgRect
}

func parseOutAnnotationType(fullTypeString: String) -> String {
  var type = "none"

  if fullTypeString.hasSuffix("highlight") {
    type = "highlight"
  } else if fullTypeString.hasSuffix("underline") {
    type = "underline"
  }

  return type
}

func convertPDFAnnotationToDictionary(pdfAnnotation: PDFAnnotation) -> [String: Any] {
  //print("just printing stuff")
  var dict: [String: Any] = [:]

  let cgRectBBox = createRectFromDouble(doubleArray: pdfAnnotation.bbox!)
  let bboxString = NSStringFromCGRect(cgRectBBox)

  var cgRectsRects: [CGRect] = []
  for rect in pdfAnnotation.rects! {
    cgRectsRects.append(createRectFromDouble(doubleArray: rect))
  }

  var rectStringsArray = [String]()
  cgRectsRects.map {
    let rectString = NSStringFromCGRect($0)
    rectStringsArray.append(rectString)
  }

  let annotationType = parseOutAnnotationType(fullTypeString: pdfAnnotation.type!)

  dict = [
        "bbox": bboxString,
        "color": pdfAnnotation.color as String!,
        "opacity": pdfAnnotation.opacity as Float!,
        "pageIndex": pdfAnnotation.pageIndex as Int!,
        "rects": rectStringsArray,
        "type": annotationType as String!,
        "v": pdfAnnotation.v as Int!,
        "JSONData": pdfAnnotation.JSONData as Data!
          ]
  return dict
}

var dict = convertPDFAnnotationToDictionary(pdfAnnotation: pdfAnnotation)
print("Dictionary is: \n \(dict)")

func convertCGRectToDoubles(cgRect: CGRect) -> [Double] {
  var doublesArray: [Double] = []
  doublesArray.append(Double(cgRect.origin.x))
  doublesArray.append(Double(cgRect.origin.y))
  doublesArray.append(Double(cgRect.width))
  doublesArray.append(Double(cgRect.height))

  return doublesArray
}

func convertDictionaryToPDFAnnotation(dict: [String: Any]) -> PDFAnnotation {
  let annotation = PDFAnnotation()

  // convert bbox back to [Double]
  let bboxCGRect = CGRectFromString((dict["bbox"] as? String)!)
  annotation.bbox = convertCGRectToDoubles(cgRect: bboxCGRect)

  annotation.color = dict["color"] as? String
  annotation.opacity = dict["opacity"] as? Float
  annotation.pageIndex = dict["pageIndex"] as? Int

  // convert rects back to [[Double]]
  let rectsArray = dict["rects"] as! [String]
  var rectsCGRectsArray: [CGRect] = []
  rectsArray.map {
    rectsCGRectsArray.append(CGRectFromString($0))
  }
  var rectsDoubles: [[Double]] = []
  for rectsCGRect in rectsCGRectsArray {
    rectsDoubles.append(convertCGRectToDoubles(cgRect: rectsCGRect))
  }
  annotation.rects = rectsDoubles
  annotation.type = dict["type"] as? String
  annotation.v = dict["v"] as? Int
  annotation.JSONData = dict["JSONData"] as? Data

  return annotation
}

var annotation = convertDictionaryToPDFAnnotation(dict: dict)
print(annotation.color ?? "")
print(annotation.bbox ?? "")
print(annotation.rects ?? "")
print(annotation.type ?? "")

// Now, can we take a PDFAnnotation object, and without using JSONData,
// pass enough data back to recreate a PSPDFAnnotation?
func convertPDFAnnotationToPSPDFAnnotation(annotation: PDFAnnotation) {
  // create CGRects out of [Float]
  // and figure out what type of annotation we have from type to recreate the annotation
  var bbox: CGRect?
  var rects: [CGRect]? = []
  var type: String?

  bbox = createRectFromDouble(doubleArray: annotation.bbox!)
  print("pspdfAnnotation:bbox is: \(String(describing: bbox))")

  for rect in annotation.rects! {
    rects?.append(createRectFromDouble(doubleArray: rect))
  }
  print("pspdfAnnotation:rects is: \(String(describing: rects))")

  type = parseOutAnnotationType(fullTypeString: annotation.type!)
  print("pspdfAnnotation:type is: \(String(describing: type))")
}

convertPDFAnnotationToPSPDFAnnotation(annotation: annotation)
