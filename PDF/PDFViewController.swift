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

public class PDFViewController: PSPDFViewController {

  var documentName = "FinancialAccounting"

  public static let sharedInstance = PDFViewController()

  private init() {
    super.init(document: nil, configuration: nil)
  }

  @available(*, unavailable)
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override public func viewDidLoad() {
    super.viewDidLoad()
  PSPDFKit.setLicenseKey("ayMdJS9o1bNAIcD2RRW4EBCT8kIbBAMIQOzZ+AuONFXi3AiEMHRcpVB7tOLb0ocsbu2+EJopWzHGHWE5sYEW0yVGpQR7N18+pijQUCwd0mF9jVBARvqviQl0bNlF9neeMDJWC4M7PXkfUjshPo7d2AZcwQgq8L8v2yZEpqGgzUq8xJwBI/xjhi6gjoazNJ+XHad91vxcfF60mrYDh9mIRcgAIdnI5IHy4w7pYV6w5wx3KftFTMYbQki1h298jARu3sHhecN58Y2MjsxMvo8cDsIMBUbGr/uqI9+jydXOf/eHw+qdYxqszCjPV5myMvUyIYpYGWkVwx+APcN6Z4+58qh0qAxf9n+LuS6UtKft/4FvQE8R7hvqePFfPTuu77sIWVAWzpYaw8d+rpXkcPs7yGZTImjeaxy+IkJZP5+jYne/6zPp7mMO1ma634ErcP0H")


    delegate = self as PSPDFViewControllerDelegate

    // set up the regular menu bar
    navigationItem.setRightBarButtonItems([thumbnailsButtonItem, outlineButtonItem, bookmarkButtonItem, searchButtonItem, annotationButtonItem, activityButtonItem, settingsButtonItem], animated: false)

    // set up the menu bar for when we're in thumbnail view, but do not include the document editing button
    navigationItem.setRightBarButtonItems([thumbnailsButtonItem], for: .thumbnails, animated: false)

    let fileURL = Bundle(identifier: "edu.umn.minitex.simplye.PDF")?.url(forResource: documentName, withExtension: "pdf")
    document = PSPDFDocument(url: fileURL!)

    self.document = document
    self.updateConfiguration(builder: { builder in
      builder.searchResultZoomScale = 1
      builder.backgroundColor = UIColor.lightGray
    })

  }

}

extension PDFViewController: PSPDFViewControllerDelegate {
  func pdfViewController(_ pdfController: PSPDFViewController, didConfigurePageView pageView: PSPDFPageView) {
    print("Page loaded: %@", pageView)
  }
}
