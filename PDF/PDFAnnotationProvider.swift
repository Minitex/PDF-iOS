//
//  PDFAnnotationProvider.swift
//  PDF
//
//  Created by Vui Nguyen on 1/11/18.
//  Copyright © 2018 Minitex. All rights reserved.
//

import PSPDFKit

class PDFAnnotationProvider: PSPDFContainerAnnotationProvider {

  // make sure there is an allAnnotations object
  // and an page: annotations dictionary object(s)
  var pdfModuleDelegate: PDFViewControllerDelegate

  init(documentProvider: PSPDFDocumentProvider, pdfModuleDelegate: PDFViewControllerDelegate) {
    self.pdfModuleDelegate = pdfModuleDelegate
    super.init(documentProvider: documentProvider)
  }

  /*
  override init(documentProvider: PSPDFDocumentProvider) {
    super.init(documentProvider: documentProvider)
  }
 */
  
  override func add(_ annotations: [PSPDFAnnotation], options: [String : Any]? = nil) -> [PSPDFAnnotation]? {
    super.add(annotations, options: options)

    // convert to JSON and pass it off to the host app

    print("an annotation was added!")

    var jsonData = Data()

    for annotation in annotations {
      print(annotation)
      do {
        //let jsonData: Data = try annotation.generateInstantJSON()
        jsonData.append(try annotation.generateInstantJSON())
        //let jsonDataString = String(data: jsonData, encoding: String.Encoding.utf8)
        //print(jsonDataString ?? "no string value here")
      }
      catch {
        print("Error: Generate InstantJSON!!")
      }
    }

    pdfModuleDelegate.saveAnnotations(annotations: jsonData)
    return annotations
  }

}
