//
//  ViewController.swift
//  PDFExample
//
//  Created by Vui Nguyen on 11/14/17.
//  Copyright © 2017 Minitex. All rights reserved.
//
import PDF
import UIKit

class ViewController: UIViewController {

  @IBAction func openPDF(_ sender: Any) {
    let pdfViewController = PDFViewController(licenseKey: APIKeys.PDFLicenseKey)
    self.navigationController?.pushViewController(pdfViewController, animated: true)
  }
}
