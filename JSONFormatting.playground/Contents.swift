//: This Playground is for testing code for JSON formatting
// we want to convert one type of JSON (PSPDFKit instant JSON)
// to another format (that the SimplyE server will persist)

import Foundation

let json = """
[
{
  "bbox": [57.141815185546875, 277.3717041015625, 214.94198608398438, 9.752716064453125],
  "color": "#000000",
  "opacity": 1,
  "pageIndex": 63,
  "rects": [[56.166545867919922, 276.39642333984375, 216.89253234863281, 11.7032470703125]],
  "type": "pspdfkit/markup/underline",
  "v": 1
}
]
""".data(using: .utf8)!

// this is the format we expect to get from PSPDFKit
struct PDFJSON: Codable {
  var bbox: [Float]
  var color: String
  var opacity: Float
  var pageIndex: Int
  var rects: [[Float]]
  var type: String
  var v: Int
}

// this is the format we plan to send to the SimplyE server
struct ServerJSON: Codable {
  var context: String
  var type: String
  var body: Body
  var target: String

  private enum CodingKeys: String, CodingKey {
    case context = "@context"
    case type = "type"
    case body = "body"
    case target = "target"
  }

  struct Body: Codable {
    var type: String
    var value: String
  }
}

// this is where we take the PSPDFJSON data and re-format it
// into the ServerJSON format

extension ServerJSON {
  init(from pdfJson: PDFJSON) {
    context = "http://www.w3.org/ns/anno.jsonld"
    type = "Annotation"

    var annotationValue: String = "stuff"
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    do {
      let pdfJSON = try decoder.decode([PDFJSON].self, from: json)
      let pdfJSONValue = try encoder.encode(pdfJSON[0])
      annotationValue = String(data: pdfJSONValue, encoding: .utf8)!
    } catch {

    }

    body = Body(type: "PSPDFKitAnnotation", value: annotationValue)
    target = "http://circulation-manager/book"
  }
}

print("hi")
let decoder = JSONDecoder()
let pdfJSON = try decoder.decode([PDFJSON].self, from: json)
print(pdfJSON)

let serverJSON = pdfJSON.map { ServerJSON(from: $0) }
print(serverJSON)

let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted
let serverJSONData = try encoder.encode(serverJSON)
print(String(data: serverJSONData, encoding: .utf8) ?? "print something")

let pdfJSONPretty = try encoder.encode(pdfJSON)
print(String(data: pdfJSONPretty, encoding: .utf8) ?? "print something")
