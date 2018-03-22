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

    //let textColor = UIColor.black
    let textColor = UIColor.orange
    //let textColor = UIColor.blue
    let textColorString = UIColorToHexString(uicolor: textColor)
    let reloadedColor = hexStringToUIColor(hex: textColorString)
    print(textColorString)
    print(reloadedColor)

    label.textColor = reloadedColor
    view.addSubview(label)
    self.view = view
  }

}

func hexStringToUIColor (hex: String) -> UIColor {
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

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
