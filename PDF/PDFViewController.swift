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
import MinitexPDFProtocols

/*
public protocol PDFViewControllerDelegate: class {
  func userDidNavigate(page: Int)
  func saveBookmarks(pageNumbers: [UInt])
  func saveAnnotations(annotationsData: [Data])
  func saveAnnotations(annotations: [PDFAnnotation])
}
 */

/*
public protocol PDFViewControllerDelegate: MinitexPDFViewControllerDelegate {

}
 */

public final class PDFViewController: PSPDFViewController {

  //weak var pdfModuleDelegate: PDFViewControllerDelegate?
  weak var pdfModuleDelegate: MinitexPDFViewControllerDelegate?

  // This initializer is now deprecated with passing annotations as PDFAnnotation objects
  /*
  public init(documentURL: URL, openToPage page: UInt = 0, bookmarks pages: [UInt] = [],
              annotations annotationsData: [Data] = [], PSPDFKitLicense: String, delegate: PDFViewControllerDelegate?) {

    PSPDFKit.setLicenseKey(PSPDFKitLicense)
    let document = PSPDFDocument(url: documentURL)

    document.annotationSaveMode = PSPDFAnnotationSaveMode.externalFile
    document.didCreateDocumentProviderBlock = { (documentProvider: PSPDFDocumentProvider) -> Void in
    documentProvider.annotationManager.annotationProviders = [PDFAnnotationProvider(annotationObjects: annotationsData,
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
 */

  public init(documentURL: URL, openToPage page: UInt = 0, bookmarks pages: [UInt] = [],
              annotations annotationObjects: [PDFAnnotation] = [],
              //PSPDFKitLicense: String, delegate: PDFViewControllerDelegate?) {
              PSPDFKitLicense: String, delegate: MinitexPDFViewControllerDelegate?) {

    PSPDFKit.setLicenseKey(PSPDFKitLicense)
    let document = PSPDFDocument(url: documentURL)

    document.annotationSaveMode = PSPDFAnnotationSaveMode.externalFile
    document.didCreateDocumentProviderBlock = { (documentProvider: PSPDFDocumentProvider) -> Void in
      documentProvider.annotationManager.annotationProviders =
        [PDFAnnotationProvider(annotationObjects: annotationObjects,
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

    // add only highlight and underline to the annotations toolbar
    let highlight = PSPDFAnnotationGroupItem(type: .highlight)
    let underline = PSPDFAnnotationGroupItem(type: .underline)

    // for iphone
    let annotationCompactGroup: [PSPDFAnnotationGroup] = [PSPDFAnnotationGroup(items: [highlight]),
                                                          PSPDFAnnotationGroup(items: [underline])]
    let annotationCompactToolbarConfiguration =
      PSPDFAnnotationToolbarConfiguration(annotationGroups: annotationCompactGroup)

    // for ipad
    let annotationRegularGroup: [PSPDFAnnotationGroup] = [PSPDFAnnotationGroup(items: [highlight]),
                                                          PSPDFAnnotationGroup(items: [underline])]
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
