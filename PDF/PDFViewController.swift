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
  func userNavigatedToPage(pageNumber: UInt, forBookId: String)
}

public final class PDFViewController: PSPDFViewController {

  var bookId: String?
  var pdfModuleDelegate: PDFViewControllerDelegate?

  public init(licenseKey: String, bookId: String, fileURL: URL, lastPageRead: UInt = 0, delegate: PDFViewControllerDelegate) {

    PSPDFKit.setLicenseKey(licenseKey)
    let document = PSPDFDocument(url: fileURL)
    document.bookmarkManager?.provider = [PDFBookmarkProvider()]
    
    let configuration = PSPDFConfiguration { builder in
      builder.searchResultZoomScale = 1
      builder.backgroundColor = UIColor.lightGray
    }

    super.init(document: document, configuration: configuration)

    self.pdfModuleDelegate = delegate
    self.bookId = bookId
    // open PDF to the lastPageRead
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
  public func pdfViewController(_ pdfController: PSPDFViewController, willBeginDisplaying pageView: PSPDFPageView, forPageAt pageIndex: Int) {

    pdfModuleDelegate?.userNavigatedToPage(pageNumber: UInt(pageIndex), forBookId: bookId!)

    #if DEBUG
      print("willBeginDisplaying::pageIndex loaded:", pageIndex)
    #endif
  }
}
