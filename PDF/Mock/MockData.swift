//
//  MockData.swift
//  PDF
//
//  Created by Vui Nguyen on 2/23/18.
//  Copyright © 2018 Minitex. All rights reserved.
//

import Foundation

class MockData: MockPDFViewControllerDelegateDelegate {
  var books: [Book]?

  // current book
  var book: Book?
  static var documentDirectoryURL: URL {
    return try! FileManager.default.url(
      for: .documentDirectory,
      in: .userDomainMask,
      appropriateFor: nil,
      create: false
    )
  }

  let booksPlistURL: URL = URL(fileURLWithPath: "Books",
                               relativeTo: documentDirectoryURL).appendingPathExtension("plist")
  let bundleId = "edu.umn.minitex.simplye.PDF"

  init() {
    // copy the plist from the bundle to the user's documents directory,
    // so that it can be edited
    let booksPlistPathInBundle: URL =
      (Bundle(identifier: bundleId)?.url(forResource: "Books", withExtension: "plist")!)!
    if !FileManager.default.fileExists(atPath: booksPlistURL.path) {
      do {
        try FileManager.default.copyItem(at: booksPlistPathInBundle, to: booksPlistURL)
      } catch {
        print(error)
      }
    }

    // pull contents of Books plist file into internal Book array
    do {
      let data = try Data(contentsOf: booksPlistURL)
      let decoder = PropertyListDecoder()
      books = try decoder.decode([Book].self, from: data)
      #if DEBUG
        print(books ?? "no books value")
      #endif

      book = books![0]
    } catch {
      print(error)
    }
  }

  // you DON'T want these lazy loaded so we can reload the data
  // when the Books.plist changes
  var lastPageRead: UInt {
    var lastPageRead: UInt = 0
    lastPageRead = (book?.lastPageRead)!
    return lastPageRead
  }

  var bookmarkPages: [UInt] {
    var bookmarkPages: [UInt] = []
    bookmarkPages = (book?.bookmarks)!
    return bookmarkPages
  }

  var annotationsData: [Data] {
    var annotationsData: [Data] = []
    annotationsData = (book?.annotations)!
    return annotationsData
  }

  var documentURL: URL {
    let documentName = book?.title
    let fileURL = Bundle(identifier: bundleId)?.url(forResource: documentName, withExtension: "pdf")
    return fileURL!
  }

  // MockPDFViewControllerDelegateDelegate
  func persistLastPageRead(page: Int) {
    print("in MockData: persistLastPageRead")
    book?.lastPageRead = UInt(page)
    let encoder = PropertyListEncoder()
    encoder.outputFormat = .xml

    // save changes to books array to the Books.plist file
    do {
      let data = try encoder.encode(books)
      try data.write(to: booksPlistURL, options: .atomic)
    } catch {
      print(error)
    }
  }

  func persistBookmarks(pageNumbers: [UInt]) {
    print("in MockData: persistBookmarks")
  }

  func persistAnnotations(annotationsData: [Data]) {
    print("in MockData: persistAnnotations")
  }}