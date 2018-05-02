//
//  ViewController.swift
//  PDFExample
//
//  Created by Vui Nguyen on 11/14/17.
//  Copyright © 2017 Minitex. All rights reserved.
//
import PDF
import UIKit
import MinitexPDFProtocols

/*
@objc public protocol PDFViewController: class {
  /*
  init(documentURL: URL, openToPage page: UInt, bookmarks pages: [UInt],
       annotations annotationObjects: [PDFAnnotation],
       PSPDFKitLicense: String, delegate: MinitexPDFViewControllerDelegate?)
 */
  init(dictionary: [String: Any])
}
 */

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

    // if we get nil, don't add it to the navigation, and instead print a message
    // if it's not nil, add it to the navigation controller
    let pdfViewController = Factory().createPDFViewController(documentURL: fileURL, openToPage: book.lastPageRead,
                                                           bookmarks: book.bookmarks, annotations: book.PDFAnnotations,
                                                           PSPDFKitLicense: APIKeys.PDFLicenseKey,
                                                           delegate: self)
    if pdfViewController != nil {
      self.navigationController?.pushViewController(pdfViewController!, animated: true)
    } else {
      print("PDF module does not exist")
    }
  }
}

class Factory: MinitexPDFViewControllerFactory {

  // swiftlint:disable function_parameter_count
  func createPDFViewController(documentURL: URL, openToPage page: UInt, bookmarks pages: [UInt],
                               annotations annotationObjects: [PDFAnnotation], PSPDFKitLicense: String,
                               delegate: MinitexPDFViewControllerDelegate) -> UIViewController? {

    // if we can find the PDFViewController class, let's return it, else return nil
    /*
    guard let pdfViewControllerClass = NSClassFromString("PDF.PDFViewController") else {
      return nil
    }
    let pdfViewController = pdfViewControllerClass.init(documentURL: documentURL, openToPage: page,
                                                   bookmarks: pages, annotations: annotationObjects,
                                                   PSPDFKitLicense: APIKeys.PDFLicenseKey,
                                                  delegate: delegate)
 */
    let pdfViewController = PDFViewController.init(documentURL: documentURL, openToPage: page,
                                                        bookmarks: pages, annotations: annotationObjects,
                                                        PSPDFKitLicense: APIKeys.PDFLicenseKey,
                                                        delegate: delegate)
    return pdfViewController
  }
}

/*
extension ViewController: MinitexPDFViewControllerFactory {
  func createPDFViewController(documentURL: URL, openToPage page: UInt, bookmarks pages: [UInt],
                               annotations annotationObjects: [PDFAnnotation],
                               PSPDFKitLicense: String,
                               delegate: MinitexPDFViewControllerDelegate) -> PDFViewController? {

    // the NSClassFromString isn't working, use NSBundle?
   // let className = Bundle(identifier: "edu.umn.minitex.simplye.PDF")?.classNamed("PDFViewController") as String
    //print(className)
    guard let pdfViewControllerClass = NSClassFromString("edu.umn.simplye.PDF.PDFViewController")
    //  guard let pdfViewControllerClass = Bundle(identifier: "edu.umn.minitex.simplye.PDF")?.classNamed("PDFViewController")
        as? PDFViewController.Type else {
      return nil
    }
    let dictionary = ["documentURL": documentURL, "page": page, "pages": pages, "annotationObjects": annotationObjects,
                      "PSPDFKitLicense": PSPDFKitLicense, "delegate": delegate] as [String: Any]
    let pdfViewController = pdfViewControllerClass.init(dictionary: dictionary)
    return pdfViewController
  }
}
 */

extension ViewController: MinitexPDFViewControllerDelegate {
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
