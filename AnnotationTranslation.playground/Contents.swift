//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
print(str)

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

  // Comparison function
  public func isEqualToPSPDFAnnotation(compareTo: PSPDFAnnotation) -> Bool {
    var isSame = false

    guard self.pageIndex == compareTo.pageIndex else {
      print("pageIndex is not the same")
      return isSame
    }

    guard self.type == compareTo.type else {
      print("type is not the same")
      return isSame
    }

    guard self.bbox.equalTo(compareTo.bbox) else {
      print("bbox is not the same")
      return isSame
    }

    guard self.rects.elementsEqual(compareTo.rects) else {
      print("rects are not the same")
      return isSame
    }

    guard (self.color?.isEqual(compareTo.color))! else {
      print("color is not the same")
      print("self.color is \(String(describing: self.color))")
      print("compareTo.color is \(String(describing: compareTo.color))")
      return isSame
    }

    guard (self.alpha == compareTo.alpha) else {
      print("alpha is not the same")
      return isSame
    }

    isSame = true
    return isSame
  }
}

// Translation Helper Functions:

// Apple documentation:
// for NSStringFromCGRect:
// https://developer.apple.com/documentation/uikit/1624474-nsstringfromcgrect?language=objc
func createStringArrayFromNSValueArray(nsValues: [NSValue]) -> [String] {
  var stringArray: [String] = []
  stringArray = nsValues.map { (nsValue: NSValue) -> String in
    return NSStringFromCGRect(nsValue.cgRectValue)  // this is a built-in iOS function
  }
  return stringArray
}

// Apple documentation:
// for NSValue: https://developer.apple.com/documentation/foundation/nsvalue
// for CGRectFromString: https://developer.apple.com/documentation/foundation/nscoder/1624508-cgrect
func createNSValueArrayFromStringArray(stringValues: [String]) -> [NSValue] {
  var nsArray: [NSValue] = []
  nsArray = stringValues.map { (stringValue: String) -> NSValue in
    return NSValue.init(cgRect: CGRectFromString(stringValue))
  }
  return nsArray
}

// Apple documentation:
// for UIColor: https://developer.apple.com/documentation/uikit/uicolor
// for CGFloat: https://developer.apple.com/documentation/coregraphics/cgfloat
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

func hexStringToUIColor (hex: String) -> UIColor {
  // If hex is all 0's, we should return UIColor is black, otherwise weird things happen!
  if Int(hex) == 0 {
    return UIColor.black
  }

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

// Builder Functions:
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

func buildPSPDFAnnotation(from minitexAnnotation: MinitexAnnotation) -> PSPDFAnnotation? {
  var pspdfAnnotation: PSPDFAnnotation? = nil
  var type: String = ""
  var UIcolor: UIColor = .black
  var alpha: CGFloat = CGFloat(1.0)

  if minitexAnnotation.type.lowercased().hasSuffix("highlight") {
    //pspdfAnnotation = PSPDFHighlightAnnotation()  // this does not work here, only in PDF-iOS module
    type = minitexAnnotation.type
  } else if minitexAnnotation.type.lowercased().hasSuffix("underline") {
   // pspdfAnnotation = PSPDFUnderlineAnnotation()  // this does not work here, only in PDF-iOS module
    type = minitexAnnotation.type
  } else {
    return pspdfAnnotation!
  }

  // set the required attributes
  let boundingBox = CGRectFromString(minitexAnnotation.bbox)
  let pageIndex = minitexAnnotation.pageIndex
  let rects = createNSValueArrayFromStringArray(stringValues: minitexAnnotation.rects)
  let JSONData = minitexAnnotation.JSONData

  // since color and opacity are optional attributes, we will set them only if they exist
  if let color = minitexAnnotation.color {
    UIcolor = hexStringToUIColor(hex: color)
  }

  if let opacity = minitexAnnotation.opacity {
   alpha = CGFloat(floatLiteral: CGFloat.NativeType(opacity))
  }

  pspdfAnnotation = PSPDFAnnotation(pageIndex: pageIndex, type: type, bbox: boundingBox, rects: rects, color: UIcolor, alpha: alpha, JSONData: JSONData)
  return pspdfAnnotation
}

let pspdfAnnotationBBox = CGRect(x: 57.174537658691406, y: 320.7777099609375, width: 323.847412109375, height: 23.301727294921875)
let pspdfAnnotationRects = [
  NSValue(cgRect: CGRect(x: 56.199268341064453, y: 319.80242919921875, width: 325.79794311523438, height: 11.7032470703125)),
  NSValue(cgRect: CGRect(x: 381.0001220703125, y: 328.174072265625, width: 0, height: 0)),
  NSValue(cgRect: CGRect(x: 56.297451019287109, y: 333.3514404296875, width: 0168.49978637695312, height: 11.7032470703125)),
]
let pspdfAnnotationType = "pspdfkit/markup/highlight"
let pspdfAnnotation = PSPDFAnnotation(pageIndex: 1, type: pspdfAnnotationType, bbox: pspdfAnnotationBBox,
                                      rects: pspdfAnnotationRects,
                                      color: .black, alpha: 1.0, JSONData: nil)

let minitexAnnotation = buildMinitexAnnotation(from: pspdfAnnotation)
let originalPSPDFAnnotation = buildPSPDFAnnotation(from: minitexAnnotation!)

// do a check here to make sure the pspdfAnnotion has the same attributes as originalPSPDFAnnotation
// so we know the translation was done correctly
print(pspdfAnnotation.isEqualToPSPDFAnnotation(compareTo: originalPSPDFAnnotation!))

print("success!")
