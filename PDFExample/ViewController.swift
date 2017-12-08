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
    let fileURL = Bundle.main.url(forResource: documentName, withExtension: "pdf")!
    let pdfViewController = PDFViewController(licenseKey: APIKeys.PDFLicenseKey, bookId: documentName, fileURL: fileURL, lastPageRead: UInt(books![0].lastPageRead), delegate: self)
    self.navigationController?.pushViewController(pdfViewController, animated: true)
  }

  @IBAction func openPDF2(_ sender: Any) {
    let documentName = books![1].title
    let fileURL = Bundle.main.url(forResource: documentName, withExtension: "pdf")!
    let pdfViewController = PDFViewController(licenseKey: APIKeys.PDFLicenseKey, bookId: documentName, fileURL: fileURL, lastPageRead: UInt(books![1].lastPageRead), delegate: self)
    self.navigationController?.pushViewController(pdfViewController, animated: true)
  }
}

extension ViewController: PDFViewControllerDelegate {
  func userNavigatedToPage(pageNumber: UInt, forBookId: String) {


    for (index, book) in (books?.enumerated())! {
      if book.title == forBookId {

        // save last page read for a specific book to internal array
        books![index].lastPageRead = Int(pageNumber)

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
