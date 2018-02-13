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

public protocol PDFViewControllerDelegate: class {
  func userDidNavigate(page: Int)
  func saveBookmarks(pageNumbers: [UInt])
  func saveAnnotations(annotationsData: [Data])
}

public final class PDFViewController: PSPDFViewController {

  weak var pdfModuleDelegate: PDFViewControllerDelegate?

  public init(documentURL: URL, openToPage page: UInt = 0, bookmarks pages: [UInt] = [],
              annotations annotationsData: [Data] = [], PSPDFKitLicense: String, delegate: PDFViewControllerDelegate?) {

    PSPDFKit.setLicenseKey(PSPDFKitLicense)
    let document = PSPDFDocument(url: documentURL)

    document.annotationSaveMode = PSPDFAnnotationSaveMode.externalFile
    document.didCreateDocumentProviderBlock = { (documentProvider: PSPDFDocumentProvider) -> Void in
      documentProvider.annotationManager.annotationProviders = [PDFAnnotationProvider(annotationsData: annotationsData,
                                                                                    documentProvider: documentProvider,
                                                                                    pdfModuleDelegate: delegate!)]
    }

    document.bookmarkManager?.provider = [PDFBookmarkProvider(pages: pages, pdfModuleDelegate: delegate!)]

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

    navigationItem.setRightBarButtonItems([thumbnailsButtonItem, outlineButtonItem, bookmarkButtonItem,
                                           searchButtonItem, annotationButtonItem, settingsButtonItem], animated: false)

    // remove edit icon while in thumbnail view
    navigationItem.setRightBarButtonItems([thumbnailsButtonItem], for: .thumbnails, animated: false)

    // add only the highlight, underline, and ink to the annotations toolbar
    let highlight = PSPDFAnnotationGroupItem(type: PSPDFAnnotationString.highlight)
    let underline = PSPDFAnnotationGroupItem(type: PSPDFAnnotationString.underline)
    let ink       = PSPDFAnnotationGroupItem(type: PSPDFAnnotationString.ink)

    // for iphone
    let annotationCompactGroup: [PSPDFAnnotationGroup] = [PSPDFAnnotationGroup(items: [highlight]),
                                                          PSPDFAnnotationGroup(items: [underline]),
                                                          PSPDFAnnotationGroup(items: [ink])]
    let annotationCompactToolbarConfiguration =
      PSPDFAnnotationToolbarConfiguration(annotationGroups: annotationCompactGroup)

    // for ipad
    let annotationRegularGroup: [PSPDFAnnotationGroup] = [PSPDFAnnotationGroup(items: [highlight]),
                                                          PSPDFAnnotationGroup(items: [underline]),
                                                          PSPDFAnnotationGroup(items: [ink])]
    let annotationRegularToolbarConfiguration =
      PSPDFAnnotationToolbarConfiguration(annotationGroups: annotationRegularGroup)

    self.annotationToolbarController?.annotationToolbar.configurations = [annotationCompactToolbarConfiguration,
                                                                          annotationRegularToolbarConfiguration]
  }
}

extension PDFViewController: PSPDFViewControllerDelegate {
  public func pdfViewController(_ pdfController: PSPDFViewController, willBeginDisplaying pageView: PSPDFPageView,
                                forPageAt pageIndex: Int) {

    pdfModuleDelegate?.userDidNavigate(page: pageIndex)

    #if DEBUG
      print("willBeginDisplaying::pageIndex loaded:", pageIndex)
    #endif
  }
}
