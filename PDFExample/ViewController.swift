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

  let booksPlistURL: URL = URL(fileURLWithPath: "Books", relativeTo: documentDirectoryURL).appendingPathExtension("plist")

  required init?(coder aDecoder: NSCoder) {

    // copy the plist from the bundle to the user's documents directory,
    // so that it can be edited
    let booksPlistPathInBundle: URL = Bundle.main.url(forResource: "Books", withExtension: "plist")!
    if !FileManager.default.fileExists(atPath: booksPlistURL.absoluteString) {
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
    let documentName = books![0].title
    currentBook = documentName
    let fileURL = Bundle.main.url(forResource: documentName, withExtension: "pdf")!
    let pdfViewController = PDFViewController.init(documentURL: fileURL, openToPage: UInt(books![0].lastPageRead), PSPDFKitLicense: APIKeys.PDFLicenseKey, delegate: self)
    self.navigationController?.pushViewController(pdfViewController, animated: true)
  }

  @IBAction func openPDF2(_ sender: Any) {
    let documentName = books![1].title
    currentBook = documentName
    let fileURL = Bundle.main.url(forResource: documentName, withExtension: "pdf")!
    let pdfViewController = PDFViewController.init(documentURL: fileURL, openToPage: UInt(books![1].lastPageRead), PSPDFKitLicense: APIKeys.PDFLicenseKey, delegate: self)
    self.navigationController?.pushViewController(pdfViewController, animated: true)
  }
}

extension ViewController: PDFViewControllerDelegate {

  func userDidNavigate(page: Int) {

    for (index, book) in (books?.enumerated())! {
      if book.title == self.currentBook {

        // save last page read for a specific book to internal array
        books![index].lastPageRead = page

        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml

        // save changes to books array to the Books.plist file
        do {
          let data = try encoder.encode(books)
          try data.write(to: booksPlistURL, options: .atomic)
        }
        catch {
          print(error)
        }

        // once we find the right book, can stop iterating through array
        break
      }
    }
  }

}
