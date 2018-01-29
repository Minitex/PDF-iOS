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
  func saveBookmarks(pageNumbers: [UInt])
  func saveAnnotations(annotationsData: [Data])
}

public final class PDFViewController: PSPDFViewController {

  var pdfModuleDelegate: PDFViewControllerDelegate?

  public init(documentURL: URL, openToPage page: UInt = 0, bookmarks pages: [UInt] = [], annotations annotationsData: [Data] = [], PSPDFKitLicense: String, delegate: PDFViewControllerDelegate?) {

    PSPDFKit.setLicenseKey(PSPDFKitLicense)
    let document = PSPDFDocument(url: documentURL)

    document.annotationSaveMode = PSPDFAnnotationSaveMode.externalFile
    
    document.didCreateDocumentProviderBlock = { (documentProvider: PSPDFDocumentProvider) -> Void in
      documentProvider.annotationManager.annotationProviders = [PDFAnnotationProvider(annotationsData: annotationsData, documentProvider: documentProvider, pdfModuleDelegate: delegate!)]
    }

    document.bookmarkManager?.provider = [PDFBookmarkProvider(pages: pages, pdfModuleDelegate: delegate!)]

    let configuration = PSPDFConfiguration { builder in
      builder.searchResultZoomScale = 1
      builder.backgroundColor = UIColor.lightGray
      //builder.editableAnnotationTypes = []  // disable editing annotations for now
    }


    super.init(document: document, configuration: configuration)
    self.delegate = self

    self.pdfModuleDelegate = delegate
    self.pageIndex = page

/*
    var observer = NotificationCenter.default.addObserver(forName: .PSPDFAnnotationsAdded, object: nil, queue: OperationQueue.main) { [weak self] (notification) in

      //guard self != nil else { return }

      guard let pdfController = self else { return }

      if pdfController.annotationStateManager.state == .ink {
        print("from Observer: ink annotation added!")
      }

    }
*/

  }

  @available(*, unavailable)
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override public func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.setRightBarButtonItems([thumbnailsButtonItem, outlineButtonItem, bookmarkButtonItem, searchButtonItem, annotationButtonItem, settingsButtonItem], animated: false)

    // remove edit icon while in thumbnail view
    navigationItem.setRightBarButtonItems([thumbnailsButtonItem], for: .thumbnails, animated: false)

    // remove the image and the signature annotations from the annotation toolbar
    var annotatationTypes = configuration.editableAnnotationTypes
    annotatationTypes.remove(PSPDFAnnotationString.image)
    annotatationTypes.remove(PSPDFAnnotationString.signature)
    annotationToolbarController?.annotationToolbar.editableAnnotationTypes = annotatationTypes
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
