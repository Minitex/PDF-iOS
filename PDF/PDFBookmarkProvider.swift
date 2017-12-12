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

  func add(_ bookmark: PSPDFBookmark) -> Bool {
    print("PDFBookmarkProvider, add called")
    return true
  }

  func remove(_ bookmark: PSPDFBookmark) -> Bool {
    print("PDFBookmarkProvider, remove called")
    return true
  }

  func save() {
    print("PDFBookmarkProvider, save called")
  }
}
