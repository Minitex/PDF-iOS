//
//  PDFAnnotation.swift
//  PDF
//
//  Created by Vui Nguyen on 3/1/18.
//  Copyright © 2018 Minitex. All rights reserved.
//

import Foundation

public class PDFAnnotation {
  var JSONData: Data?

  init(JSONData: Data) {
    self.JSONData = JSONData
  }
}
