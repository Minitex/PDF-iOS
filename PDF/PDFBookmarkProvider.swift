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
  var pdfViewControllerDelegate: PDFViewControllerDelegate

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

  init(pages: [UInt] = [], pdfViewControllerDelegate: PDFViewControllerDelegate) {
    self.bookmarks = []
    self.pdfViewControllerDelegate = pdfViewControllerDelegate
    if pages.count > 0 {
      for page in pages {
        self.bookmarks.append(PSPDFBookmark(pageIndex: page))
      }
    }
  }
  
  func add(_ bookmark: PSPDFBookmark) -> Bool {
    print("PDFBookmarkProvider, add called")
    print("value of bookmark: \(bookmark)")

    let index = bookmarks.index(of: bookmark)
    if index == nil {
      bookmarks.append(bookmark)
    }
    else {
      bookmarks[index!] = bookmark
    }
    print("PDFBookmarkProvider: pageNumbers are: \(pageNumbers)")
    pdfViewControllerDelegate.saveBookmarks(pageNumbers: pageNumbers)
    return true
  }

  func remove(_ bookmark: PSPDFBookmark) -> Bool {
    print("PDFBookmarkProvider, remove called")
    print("value of bookmark: \(bookmark)")

    let index = bookmarks.index(of: bookmark)
    if bookmarks.contains(bookmark) {
      bookmarks.remove(at: index!)
    }
    print("PDFBookmarkProvider: pageNumbers are: \(pageNumbers)")
    pdfViewControllerDelegate.saveBookmarks(pageNumbers: pageNumbers)
    return true
  }

  func save() {
    print("PDFBookmarkProvider, save called")
    pdfViewControllerDelegate.saveBookmarks(pageNumbers: pageNumbers)
  }
}
