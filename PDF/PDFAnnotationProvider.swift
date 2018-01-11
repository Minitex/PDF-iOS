//
//  PDFAnnotationProvider.swift
//  PDF
//
//  Created by Vui Nguyen on 1/11/18.
//  Copyright © 2018 Minitex. All rights reserved.
//

import PSPDFKit

class PDFAnnotationProvider: PSPDFContainerAnnotationProvider {

  override init(documentProvider: PSPDFDocumentProvider) {
    super.init(documentProvider: documentProvider)
  }
  
  override func add(_ annotations: [PSPDFAnnotation], options: [String : Any]? = nil) -> [PSPDFAnnotation]? {
    super.add(annotations, options: options)

    // convert to JSON and pass it off to the host app
    // but first, add a print statement
    // and then later, print the JSON

    print("an annotation was added!")

    for annotation in annotations {
      do {
        let jsonData: Data = try annotation.generateInstantJSON()

        print(jsonData)
      }
      catch {
        print("Error: Generate InstantJSON!!")
      }
    }
    return annotations
  }

}
