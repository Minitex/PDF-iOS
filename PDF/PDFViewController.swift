//
//  PDFViewController.swift
//  PDF
//
//  Created by Vui Nguyen on 11/14/17.
//  Copyright © 2017 Minitex. All rights reserved.
//
import UIKit
import PSPDFKit
import PSPDFKitUI

public final class PDFViewController: PSPDFViewController {

  var documentName = "FinancialAccounting"

  public init(licenseKey: String) {
    PSPDFKit.setLicenseKey(licenseKey)

    super.init(document: nil, configuration: nil)

    // we can't initialize document before calling super.init (calling self.document before init is bad),
    // so we'll do it here
    let fileURL = Bundle(identifier: "edu.umn.minitex.simplye.PDF")?.url(forResource: documentName, withExtension: "pdf")

    self.document = PSPDFDocument(url: fileURL!)
    self.updateConfiguration(builder: { builder in
      builder.searchResultZoomScale = 1
      builder.backgroundColor = UIColor.lightGray
    })
  }

  @available(*, unavailable)
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override public func viewDidLoad() {
    super.viewDidLoad()

    delegate = self as PSPDFViewControllerDelegate

    // set up the regular menu bar
    navigationItem.setRightBarButtonItems([thumbnailsButtonItem, outlineButtonItem, bookmarkButtonItem, searchButtonItem, annotationButtonItem, activityButtonItem, settingsButtonItem], animated: false)

    // set up the menu bar for when we're in thumbnail view, but do not include the document editing button
    navigationItem.setRightBarButtonItems([thumbnailsButtonItem], for: .thumbnails, animated: false)
  }

}

extension PDFViewController: PSPDFViewControllerDelegate {
  func pdfViewController(_ pdfController: PSPDFViewController, didConfigurePageView pageView: PSPDFPageView) {
    print("Page loaded: %@", pageView)
  }
}
