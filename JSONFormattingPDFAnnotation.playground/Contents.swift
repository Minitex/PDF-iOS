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
struct PDFAnnotation: Codable {
  var bbox: [Float]?
  var color: String?
  var opacity: Float?
  var pageIndex: Int?
  var rects: [[Float]]?
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
print(pdfAnnotation)

// Now, can we take this, and without using JSONData, pass enough data back to recreate a
// PSPDFAnnotation?
