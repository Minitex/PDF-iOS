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
  func userDidNavigate(page: Int)
}

public final class PDFViewController: PSPDFViewController {

  var pdfModuleDelegate: PDFViewControllerDelegate?

  public init(documentURL: URL, openToPage page: UInt = 0, PSPDFKitLicense: String, delegate: PDFViewControllerDelegate?) {

    PSPDFKit.setLicenseKey(PSPDFKitLicense)

    let document = PSPDFDocument(url: documentURL)
    document.bookmarkManager?.provider = [PDFBookmarkProvider()]
    let configuration = PSPDFConfiguration { builder in
      builder.searchResultZoomScale = 1
      builder.backgroundColor = UIColor.lightGray
    }

    super.init(document: document, configuration: configuration)
    self.delegate = self

    self.pdfModuleDelegate = delegate
    self.pageIndex = page
  }

  @available(*, unavailable)
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override public func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.setRightBarButtonItems([thumbnailsButtonItem, outlineButtonItem, bookmarkButtonItem, searchButtonItem, settingsButtonItem], animated: false)
    navigationItem.setRightBarButtonItems([thumbnailsButtonItem], for: .thumbnails, animated: false)
  }
}

extension PDFViewController: PSPDFViewControllerDelegate {
  public func pdfViewController(_ pdfController: PSPDFViewController, willBeginDisplaying pageView: PSPDFPageView, forPageAt pageIndex: Int) {

    pdfModuleDelegate?.userDidNavigate(page: pageIndex)

    #if DEBUG
      print("willBeginDisplaying::pageIndex loaded:", pageIndex)
    #endif
  }
}
