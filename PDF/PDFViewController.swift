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

public protocol PDFViewControllerDelegate {
  func userNavigatedToPage(index: UInt) 
}

public final class PDFViewController: PSPDFViewController {

  var savedLastPageRead: UInt?

  public init(licenseKey: String, fileURL: URL, lastPageRead: UInt = 0) {
    PSPDFKit.setLicenseKey(licenseKey)

    super.init(document: nil, configuration: nil)

    self.document = PSPDFDocument(url: fileURL)
    self.updateConfiguration(builder: { builder in
      builder.searchResultZoomScale = 1
      builder.backgroundColor = UIColor.lightGray
    })

    // go to lastPageRead
    self.pageIndex = lastPageRead
  }

  @available(*, unavailable)
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override public func viewDidLoad() {
    super.viewDidLoad()

    delegate = self as PSPDFViewControllerDelegate

    // set up the regular menu bar
    navigationItem.setRightBarButtonItems([thumbnailsButtonItem, outlineButtonItem, bookmarkButtonItem, searchButtonItem, settingsButtonItem], animated: false)

    // set up the menu bar for when we're in thumbnail view, but do not include the document editing button
    navigationItem.setRightBarButtonItems([thumbnailsButtonItem], for: .thumbnails, animated: false)
  }

}

extension PDFViewController: PSPDFViewControllerDelegate {
  func pdfViewController(_ pdfController: PSPDFViewController, didConfigurePageView pageView: PSPDFPageView) {
    print("Page loaded: %@", pageView)
  }

  public func pdfViewController(_ pdfController: PSPDFViewController, willBeginDisplaying pageView: PSPDFPageView, forPageAt pageIndex: Int) {

    savedLastPageRead = UInt(pageIndex)
    print("willBeginDisplaying::pageIndex loaded:", pageIndex)
  }
}
