//
//  PSPDFKitRendererProvider.swift
//  PSPDFKitRendererProvider
//
//  Created by Vui Nguyen on 4/12/18.
//  Copyright © 2018 Minitex. All rights reserved.
//

import PSPDFKit
import PSPDFKitUI
import PDFExample

class PSPDFKitRendererProvider: PSPDFViewController {
  weak var pdfModuleDelegate: PDFRendererProviderDelegate?

  init(documentURL: URL, openToPage page: UInt = 0, bookmarks pages: [UInt] = [],
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
}

extension PSPDFKitRendererProvider: PSPDFViewControllerDelegate {
  public func pdfViewController(_ pdfController: PSPDFViewController, willBeginDisplaying pageView: PSPDFPageView,
                                forPageAt pageIndex: Int) {

    pdfModuleDelegate?.userDidNavigate(page: pageIndex)

    #if DEBUG
    print("willBeginDisplaying::pageIndex loaded:", pageIndex)
    #endif
  }
}
