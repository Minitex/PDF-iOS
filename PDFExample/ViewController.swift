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
  let booksURL: URL = Bundle.main.url(forResource: "Books", withExtension: "plist")!

  required init?(coder aDecoder: NSCoder) {
    // let's start by reading in the plist
    // and then print the values to the console
    do {
      let data = try Data(contentsOf: booksURL)
      let decoder = PropertyListDecoder()
      books = try decoder.decode([Book].self, from: data)
      print(books ?? "no books value")
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

    // save off the page for a specific book
    for (index, book) in (books?.enumerated())! {
      if book.title == forBookId {
        books![index].lastPageRead = Int(pageNumber)

        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml

        do {
          let data = try encoder.encode(books)
          try data.write(to: booksURL, options: .atomic)
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
