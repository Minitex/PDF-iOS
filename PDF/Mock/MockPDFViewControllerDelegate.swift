//
//  MockPDFViewControllerDelegate.swift
//  PDF
//
//  Created by Vui Nguyen on 2/23/18.
//  Copyright © 2018 Minitex. All rights reserved.
//

import Foundation

public protocol MockPDFViewControllerDelegateDelegate: class {
  func persistLastPageRead(page: Int)
  func persistBookmarks(pageNumbers: [UInt])
  func persistAnnotations(annotationsData: [Data])
}

class MockPDFViewControllerDelegate: PDFViewControllerDelegate {

  var mockPDFViewControllerDelegateDelegate: MockPDFViewControllerDelegateDelegate?

  /*
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
  var books: [Book]?

  // current book
  var book: Book?

 */
  init(mockPDFViewControllerDelegateDelegate: MockPDFViewControllerDelegateDelegate) {
    self.mockPDFViewControllerDelegateDelegate = mockPDFViewControllerDelegateDelegate
    /*
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
 */
  }
  func userDidNavigate(page: Int) {
    print("in MockPDFViewControllerDelegate: userDidNavigate")
    mockPDFViewControllerDelegateDelegate?.persistLastPageRead(page: page)
    //for (index, book) in (books?.enumerated())! where book.title == self.currentBook {
      // save last page read for a specific book to internal array
      //books![index].lastPageRead = UInt(page)

    /*
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
 */
  }

  func saveBookmarks(pageNumbers: [UInt]) {
    print("in MockPDFViewControllerDelegate: saveBookmarks")
  }

  func saveAnnotations(annotationsData: [Data]) {
    print("in MockPDFViewControllerDelegate: saveAnnotations")
  }
}
