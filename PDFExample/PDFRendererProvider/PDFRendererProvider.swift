//
//  PDFRendererProvider.swift
//  PDF
//
//  Created by Vui Nguyen on 11/14/17.
//  Copyright © 2017 Minitex. All rights reserved.
//
import UIKit
import PSPDFKit
import PSPDFKitUI

public protocol PDFRendererProviderDelegate: class {
  func userDidNavigate(page: Int)
  func saveBookmarks(pageNumbers: [UInt])
  func saveAnnotations(annotationsData: [Data])
  func saveAnnotations(annotations: [PDFAnnotation])
}

public final class PDFRendererProvider: PSPDFViewController {

  weak var pdfModuleDelegate: PDFRendererProviderDelegate?

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
              PSPDFKitLicense: String, delegate: PDFRendererProviderDelegate?) {

    PSPDFKit.setLicenseKey(PSPDFKitLicense)
    let document = PSPDFDocument(url: documentURL)

    document.annotationSaveMode = PSPDFAnnotationSaveMode.externalFile
    document.didCreateDocumentProviderBlock = { (documentProvider: PSPDFDocumentProvider) -> Void in
      documentProvider.annotationManager.annotationProviders =
        [PDFAnnotationProvider(annotationObjects: annotationObjects,
                               documentProvider: documentProvider,
                               pdfRendererDelegate: delegate!)]
    }

    document.bookmarkManager?.provider = [PDFBookmarkProvider(pages: pages, pdfRendererDelegate: delegate!)]

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
    let highlight = PSPDFAnnotationGroupItem(type: AnnotationString.highlight)
    let underline = PSPDFAnnotationGroupItem(type: AnnotationString.underline)

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

extension PDFRendererProvider: PSPDFViewControllerDelegate {
  public func pdfViewController(_ pdfController: PSPDFViewController, willBeginDisplaying pageView: PSPDFPageView,
                                forPageAt pageIndex: Int) {

    pdfModuleDelegate?.userDidNavigate(page: pageIndex)

    #if DEBUG
      print("willBeginDisplaying::pageIndex loaded:", pageIndex)
    #endif
  }
}
