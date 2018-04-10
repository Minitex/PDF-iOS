//
//  ViewController.swift
//  PDFExample
//
//  Created by Vui Nguyen on 11/14/17.
//  Copyright © 2017 Minitex. All rights reserved.
//
import PDF
import UIKit

class ViewController: UIViewController {
  var books: [Book]?
  var currentBook: String?

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

  required init?(coder aDecoder: NSCoder) {

    // copy the plist from the bundle to the user's documents directory,
    // so that it can be edited
    let booksPlistPathInBundle: URL = Bundle.main.url(forResource: "Books", withExtension: "plist")!
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
    } catch {
      print(error)
    }
    super.init(coder: aDecoder)
  }

  @IBAction func openPDF1(_ sender: Any) {
    openPDF(bookIndex: 0)
  }

  @IBAction func openPDF2(_ sender: Any) {
    openPDF(bookIndex: 1)
  }

  private func openPDF(bookIndex: Int) {
    let book: Book = books![bookIndex]
    let documentName = book.title
    currentBook = documentName
    let fileURL = Bundle.main.url(forResource: documentName, withExtension: "pdf")!
    let writeableURL = copyToWriteableLocation(url: fileURL, documentName: documentName)
    let pdfViewController = PDFViewController.init(documentURL: writeableURL, openToPage: book.lastPageRead,
                                                   bookmarks: book.bookmarks, annotations: book.PDFAnnotations,
                                                   PSPDFKitLicense: APIKeys.PDFLicenseKey, delegate: self)
    self.navigationController?.pushViewController(pdfViewController, animated: true)
  }

  // as of PSPDFKit SDK 7.4.x, the PDF document must be located in a writeable directory
  // in order for bookmarks to be enabled
  private func copyToWriteableLocation(url: URL, documentName: String) -> URL {
    let writeableURL: URL = URL(fileURLWithPath: documentName,
                                relativeTo: ViewController.documentDirectoryURL).appendingPathExtension("pdf")
    if !FileManager.default.fileExists(atPath: writeableURL.path) {
      do {
        try FileManager.default.copyItem(at: url, to: writeableURL)
        print("PDF document copied over successfully!")
      } catch {
        print(error)
      }
    } else {
      print("PDF file already exists there!")
    }
    return writeableURL
  }
}

extension ViewController: PDFViewControllerDelegate {
  func saveAnnotations(annotations: [PDFAnnotation]) {
    for annotation in annotations {
      // swiftlint:disable line_length
      print("in ViewController: saveAnnotations[PDFAnnotation] called: Data is: \(String(describing: annotation.JSONData))")
      print("saveAnnotations[PDFAnnotation] called: String of Data is: \(String(data: annotation.JSONData!, encoding: String.Encoding.utf8) ?? "no string value here")")
    }
    print("\n")

    for (index, book) in (books?.enumerated())! where book.title == self.currentBook {
      books![index].PDFAnnotations = annotations

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

  }
  func saveAnnotations(annotationsData: [Data]) {

    print("saveAnnotations called!")
    for annotation in annotationsData {
      print("saveAnnotations called: Data is: \(annotation)")
      // swiftlint:disable line_length
      print("saveAnnotations called: String of Data is: \(String(data: annotation, encoding: String.Encoding.utf8) ?? "no string value here")")
    }
    print("\n")

    for (index, book) in (books?.enumerated())! where book.title == self.currentBook {
      // save annotations for a specific book to internal array
      books![index].annotations = annotationsData

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

  }

  func userDidNavigate(page: Int) {

    for (index, book) in (books?.enumerated())! where book.title == self.currentBook {
      // save last page read for a specific book to internal array
      books![index].lastPageRead = UInt(page)

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

  }

  func saveBookmarks(pageNumbers: [UInt]) {

    for (index, book) in (books?.enumerated())! where book.title == self.currentBook {
      // save bookmarks for a specific book to internal array
      books![index].bookmarks = pageNumbers

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

  }

}
