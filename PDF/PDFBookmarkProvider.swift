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

  override init() {
    bookmarks = []
  }

  init(pages: [UInt] = []) {
    bookmarks = []
    if pages.count > 0 {
      for page in pages {
        bookmarks.append(PSPDFBookmark(pageIndex: page))
      }
    }
  }
  
  // we want to pass the delegate in here, so the delegate / host app
  // can save off bookmarks as needed

  // or do we want to pass in a closure / function pointer?
  
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
    return true
  }

  func remove(_ bookmark: PSPDFBookmark) -> Bool {
    print("PDFBookmarkProvider, remove called")
    print("value of bookmark: \(bookmark)")

    let index = bookmarks.index(of: bookmark)
    if bookmarks.contains(bookmark) {
      bookmarks.remove(at: index!)
      return true
    } else {
      return false
    }
  }

  func save() {
    print("PDFBookmarkProvider, save called")
  }
}
