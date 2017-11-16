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

  // viewDidLoad will not work for us
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.

    // The bit of code below does NOT work
/*
    let pdfViewController = PDFViewController(nibName: nil, bundle: nil)
    //let pdfViewController = PDFViewController()
    self.present(pdfViewController, animated: false, completion: nil)
*/
  }

  override func viewDidAppear(_ animated: Bool) {

    let pdfViewController = PDFViewController(nibName: nil, bundle: nil)
    //let pdfViewController = PDFViewController()
    self.present(pdfViewController, animated: false, completion: pdfViewController.presentPSPDFView)

  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

