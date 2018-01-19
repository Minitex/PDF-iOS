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
    let documentName = books![0].title
    currentBook = documentName
    let fileURL = Bundle.main.url(forResource: documentName, withExtension: "pdf")!
    let annotationsData = readAnnotionsData(currentTitle: documentName)
    let pdfViewController = PDFViewController.init(documentURL: fileURL, openToPage: books![0].lastPageRead, bookmarks: books![0].bookmarks, annotations: annotationsData, PSPDFKitLicense: APIKeys.PDFLicenseKey, delegate: self)
    self.navigationController?.pushViewController(pdfViewController, animated: true)
  }

  @IBAction func openPDF2(_ sender: Any) {
    let documentName = books![1].title
    currentBook = documentName
    let fileURL = Bundle.main.url(forResource: documentName, withExtension: "pdf")!
    let annotationsData = readAnnotionsData(currentTitle: documentName)
    let pdfViewController = PDFViewController.init(documentURL: fileURL, openToPage: books![1].lastPageRead, bookmarks: books![1].bookmarks, annotations: annotationsData, PSPDFKitLicense: APIKeys.PDFLicenseKey, delegate: self)
    self.navigationController?.pushViewController(pdfViewController, animated: true)
  }

  private func readAnnotionsData(currentTitle: String) -> Data {
    var annotationsData = Data()
    let fileURL: URL = URL(fileURLWithPath: currentTitle + "Annotations", relativeTo: ViewController.documentDirectoryURL).appendingPathExtension("txt")
    if FileManager.default.fileExists(atPath: fileURL.path) {
      annotationsData.append(try! Data(contentsOf: fileURL))
    }
    print("readAnnotationsData called: Data is: \(annotationsData)")
    print("readAnnotationsData called: String of Data is: \(String(data: annotationsData, encoding: String.Encoding.utf8) ?? "no string value here")")
    return annotationsData
  }
}

extension ViewController: PDFViewControllerDelegate {

  func saveAnnotations(annotations: Data) {
    print("saveAnnotations called: Data is: \(annotations)")
    print("saveAnnotations called: String of Data is: \(String(data: annotations, encoding: String.Encoding.utf8) ?? "no string value here")")

    for (index, book) in (books?.enumerated())! {
      if book.title == self.currentBook {

        // create a file in the user's documents directory, if it doesn't already exist
        // write to that file (in bytes) overwriting whatever was already there
        let fileURL: URL = URL(fileURLWithPath: books![index].title + "Annotations", relativeTo: ViewController.documentDirectoryURL).appendingPathExtension("txt")

        if !FileManager.default.fileExists(atPath: fileURL.path) {
          FileManager.default.createFile(atPath: fileURL.path, contents: annotations, attributes: nil)

          if FileManager.default.fileExists(atPath: fileURL.path) {
            print("file created!")
          } else {
            print("file not created!")
          }

        } else {
          do {
            try annotations.write(to: fileURL)
          }
          catch {
            print(error)
          }
        }

        // once we find the right book, can stop iterating through array
        break
      }
    }

  }

  func userDidNavigate(page: Int) {

    for (index, book) in (books?.enumerated())! {
      if book.title == self.currentBook {

        // save last page read for a specific book to internal array
        books![index].lastPageRead = UInt(page)

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

  func saveBookmarks(pageNumbers: [UInt]) {
    
    for (index, book) in (books?.enumerated())! {
      if book.title == self.currentBook {

        // save bookmarks for a specific book to internal array
        books![index].bookmarks = pageNumbers

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
