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

  var lastPageReadPDF1 = 0
  var lastPageReadPDF2 = 0

  @IBAction func openPDF1(_ sender: Any) {
    let documentName = "FinancialAccounting"
    let fileURL = Bundle.main.url(forResource: documentName, withExtension: "pdf")!
    let pdfViewController = PDFViewController(licenseKey: APIKeys.PDFLicenseKey, fileURL: fileURL, lastPageRead: 293)
    self.navigationController?.pushViewController(pdfViewController, animated: true)
  }

  @IBAction func openPDF2(_ sender: Any) {
    let documentName = "DataModeling"
    let fileURL = Bundle.main.url(forResource: documentName, withExtension: "pdf")!
    let pdfViewController = PDFViewController(licenseKey: APIKeys.PDFLicenseKey, fileURL: fileURL, lastPageRead: 18)
    self.navigationController?.pushViewController(pdfViewController, animated: true)
  }
}

extension ViewController: PDFViewControllerDelegate {
  func userNavigatedToPage(index: UInt) {
    // save off page index (to JSON?)

    // save off the page for a specific book
  }

}
