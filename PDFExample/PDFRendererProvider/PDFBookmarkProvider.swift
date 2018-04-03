//
//  PDFBookmarkProvider.swift
//  PDF
//
//  Created by Vui Nguyen on 12/12/17.
//  Copyright © 2017 Minitex. All rights reserved.
//

import PSPDFKit

class PDFBookmarkProvider: NSObject, PSPDFBookmarkProvider {

  var bookmarks: [PSPDFBookmark]
  weak var pdfModuleDelegate: PDFViewControllerDelegate?
  weak var pdfRendererDelegate: PDFRendererProviderDelegate?

  var pageNumbers: [UInt] {
    var pageNumbers: [UInt] = []
    if bookmarks.count > 0 {
      for index in 0..<bookmarks.count {
        let pageNumber = bookmarks[index].pageIndex
        pageNumbers.append(pageNumber)
      }
    }
    return pageNumbers
  }

  init(pages: [UInt] = [], pdfModuleDelegate: PDFViewControllerDelegate) {
    self.bookmarks = []
    self.pdfModuleDelegate = pdfModuleDelegate
    if pages.count > 0 {
      for page in pages {
        self.bookmarks.append(PSPDFBookmark(pageIndex: page))
      }
    }
  }

  init(pages: [UInt] = [], pdfRendererDelegate: PDFRendererProviderDelegate) {
    self.bookmarks = []
    self.pdfRendererDelegate = pdfRendererDelegate
    if pages.count > 0 {
      for page in pages {
        self.bookmarks.append(PSPDFBookmark(pageIndex: page))
      }
    }
  }

  func saveBookmarksExternally(pageNumbers: [UInt]) {
    pdfRendererDelegate?.saveBookmarks(pageNumbers: pageNumbers)
  }

  func add(_ bookmark: PSPDFBookmark) -> Bool {
    let index = bookmarks.index(of: bookmark)
    if index == nil {
      bookmarks.append(bookmark)
    } else {
      bookmarks[index!] = bookmark
    }
    //pdfModuleDelegate?.saveBookmarks(pageNumbers: pageNumbers)
    saveBookmarksExternally(pageNumbers: pageNumbers)
    return true
  }

  func remove(_ bookmark: PSPDFBookmark) -> Bool {
    let index = bookmarks.index(of: bookmark)
    if bookmarks.contains(bookmark) {
      bookmarks.remove(at: index!)
    }
    //pdfModuleDelegate?.saveBookmarks(pageNumbers: pageNumbers)
    saveBookmarksExternally(pageNumbers: pageNumbers)
    return true
  }

  func save() {
   // pdfModuleDelegate?.saveBookmarks(pageNumbers: pageNumbers)
    saveBookmarksExternally(pageNumbers: pageNumbers)
  }
}
