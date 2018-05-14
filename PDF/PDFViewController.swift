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

public final class PDFViewController: PSPDFViewController {

  weak var pdfModuleDelegate: MinitexPDFViewControllerDelegate?

  public init(documentURL: URL, openToPage page: UInt = 0, bookmarks pages: [UInt] = [],
              annotations annotationObjects: [MinitexPDFAnnotation] = [],
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

extension PDFViewController: MinitexPDFViewController {
  public convenience init(dictionary: [String: Any]) {
    let documentURL: URL = (dictionary["documentURL"] as? URL)!
    let page: UInt = dictionary["openToPage"] == nil ? 0 : dictionary["openToPage"] as! UInt
    let pages: [UInt] = dictionary["bookmarks"] == nil ? [] : dictionary["bookmarks"] as! [UInt]
    let annotationObjects: [MinitexPDFAnnotation] = dictionary["annotations"] == nil ? [] :
                                            dictionary["annotations"] as! [MinitexPDFAnnotation]
    let PSPDFKitLicense: String = dictionary["PSPDFKitLicense"] as! String
    let delegate: MinitexPDFViewControllerDelegate = dictionary["delegate"] as! MinitexPDFViewControllerDelegate

    self.init(documentURL: documentURL, openToPage: page,
              bookmarks: pages,
              annotations: annotationObjects,
              PSPDFKitLicense: PSPDFKitLicense,
              delegate: delegate)
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
