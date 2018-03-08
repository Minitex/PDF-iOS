//: Playground - noun: a place where people can play

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
//print(pdfJSON)
pdfAnnotation.JSONData = json
print(pdfAnnotation.bbox ?? "")
print(pdfAnnotation.color ?? "")
print(pdfAnnotation.rects ?? "")
print(String(data: pdfAnnotation.JSONData!, encoding: String.Encoding.utf8) ?? "")
// Now, can we take this, and without using JSONData, pass enough data back to recreate a
// PSPDFAnnotation?

func createRectFromDouble(doubleArray: [Double]) -> CGRect {
  let cgRect: CGRect = CGRect(x: doubleArray[0], y: doubleArray[1], width: doubleArray[2], height: doubleArray[3])
  return cgRect
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
    let string = NSStringFromCGRect($0)
    rectStringsArray.append(string)
  }
  dict = ["boundingBox": bboxString,
          "rects": rectStringsArray]
  print(dict)
  return dict
}

convertPDFAnnotationToDictionary(pdfAnnotation: pdfAnnotation)

