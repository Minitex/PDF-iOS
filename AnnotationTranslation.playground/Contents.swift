//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
print(str)

/*
class MinitexAnnotation {
  // required
  public let pageIndex: UInt
  // required
  public let type: String
  // required
  public let bbox: String
  // required
  public let rects: [String]

  // optional
  public let color: String?
  // optional
  public let opacity: Float?
  // optional
  // we store this in case the field parsing fails, then we have the original JSON
  public let JSONData: Data?

  public init(pageIndex: UInt, type: String, bbox: String, rects: [String],
              color: String?, opacity: Float?, JSONData: Data?) {
    self.pageIndex = pageIndex
    self.type = type
    self.bbox = bbox
    self.rects = rects
    self.color = color
    self.opacity = opacity
    self.JSONData = JSONData
  }
}

class PSPDFAnnotation {
  // required
  public let pageIndex: UInt
  // required
  public let type: String
  // required
  public let bbox: CGRect
  // required
  public let rects: [NSValue]

  // optional
  public let color: UIColor?
  // optional
  public let alpha: CGFloat?
  // optional
  // we store this in case the field parsing fails, then we have the original JSON
  public let JSONData: Data?

  public init(pageIndex: UInt, type: String, bbox: CGRect, rects: [NSValue],
              color: UIColor?, alpha: CGFloat?, JSONData: Data?) {
    self.pageIndex = pageIndex
    self.type = type
    self.bbox = bbox
    self.rects = rects
    self.color = color
    self.alpha = alpha
    self.JSONData = JSONData
  }
}

let pspdfAnnotationBBox = CGRect(x: 57.174537658691406, y: 320.7777099609375, width: 323.847412109375, height: 23.301727294921875)
let pspdfAnnotationRects = [
  NSValue(cgRect: CGRect(x: 56.199268341064453, y: 319.80242919921875, width: 325.79794311523438, height: 11.7032470703125)),
  NSValue(cgRect: CGRect(x: 381.0001220703125, y: 328.174072265625, width: 0, height: 0)),
  NSValue(cgRect: CGRect(x: 56.297451019287109, y: 333.3514404296875, width: 0168.49978637695312, height: 11.7032470703125)),
]
let pspdfAnnotationType = "pspdfkit/markup/highlight"
let pspdfAnnotation = PSPDFAnnotation(pageIndex: 1, type: pspdfAnnotationType, bbox: pspdfAnnotationBBox, rects: pspdfAnnotationRects,
                                      color: .black, alpha: 1.0, JSONData: nil)

func createStringArrayFromNSValueArray(nsValues: [NSValue]) -> [String] {
  var stringArray: [String] = []
  stringArray = nsValues.map { (nsValue: NSValue) -> String in
    return NSStringFromCGRect(nsValue.cgRectValue)  // this is a built-in iOS function
  }
  return stringArray
}

func UIColorToHexString (uicolor: UIColor) -> String {
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

func buildMinitexAnnotation(from pspdfAnnotation: PSPDFAnnotation) -> MinitexAnnotation? {
  var minitexAnnotation: MinitexAnnotation? = nil

  let pageIndex = pspdfAnnotation.pageIndex
  let type = pspdfAnnotation.type
  let bbox = NSStringFromCGRect(pspdfAnnotation.bbox) // this is a built-in iOS function
  let rects = createStringArrayFromNSValueArray(nsValues: pspdfAnnotation.rects)
  let color = UIColorToHexString(uicolor: pspdfAnnotation.color!)
  let opacity = Float(pspdfAnnotation.alpha!)
  let JSONData = pspdfAnnotation.JSONData

  minitexAnnotation = MinitexAnnotation(pageIndex: pageIndex, type: type, bbox: bbox, rects: rects, color: color,
                                        opacity: opacity, JSONData: JSONData)
  return minitexAnnotation
}

buildMinitexAnnotation(from: pspdfAnnotation)

func buildPSPDFAnnotation(from minitexAnnotation: MinitexAnnotation) -> PSPDFAnnotation? {
  var pspdfAnnotation: PSPDFAnnotation? = nil

  return pspdfAnnotation
}

print("success!")
*/
