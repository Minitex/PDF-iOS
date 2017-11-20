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
    print("pressed button!")

    let bundle = Bundle(identifier: "edu.umn.minitex.simplye.PDF")
    let sb = UIStoryboard(name: "PDF", bundle: bundle)

    let pdfViewController = sb.instantiateViewController(withIdentifier: "PDF") as! PDFViewController
    self.navigationController?.pushViewController(pdfViewController, animated: true)
  }
}

