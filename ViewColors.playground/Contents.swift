//: A UIKit based Playground for presenting user interface
import UIKit
import PlaygroundSupport

class MyViewController: UIViewController {
  override func loadView() {
    let view = UIView()
    view.backgroundColor = .white

    let label = UILabel()
    label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
    label.text = "Hello World!"
    label.textColor = .black

    //let textColorHex = UIColor.blue
    //let textColorHex = UIColor.yellow
    let textColorHex = UIColor.black
    //let textColorString = textColorHex.toRGBAString()
    //let textColorString = textColorHex.toHexString()
    //let reloadedColor = UIColor(rgbaString: textColorString)
    //let reloadedColor = UIColor(hexaDecimalString: textColorString)
    //print(textColorString)
    //print(reloadedColor ?? "no color here")
   // print(UIColor(rgbaString: textColorString) ?? "no color here")

   // label.textColor = reloadedColor
    view.addSubview(label)
    self.view = view
  }

}


/*
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

    var start: String.Index?
    if hexaDecimalString.hasPrefix("#") {
      start = hexaDecimalString.index(hexaDecimalString.startIndex, offsetBy: 1)
    } else {
      start = hexaDecimalString.index(hexaDecimalString.startIndex, offsetBy: 0)
    }

      //let hexColor = hexaDecimalString.substring(from: start)
    let hexColor = String(hexaDecimalString.suffix(from: start!))

      //if hexColor.count == 8 {
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0

    if scanner.scanHexInt64(&hexNumber) {
      r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
      g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
      b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
      //a = CGFloat(hexNumber & 0x000000ff) / 255
      a = 1.0
      self.init(red: r, green: g, blue: b, alpha: a)
      return
    }
     // }


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
*/

  // Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
