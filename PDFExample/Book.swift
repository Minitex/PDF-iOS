//
//  Book.swift
//  PDFExample
//
//  Created by Vui Nguyen on 12/5/17.
//  Copyright © 2017 Minitex. All rights reserved.
//

import Foundation
import PDF

public struct Book: Codable {
  public var title: String
  public var lastPageRead: UInt
  public var bookmarks: [UInt]
  public var annotations: [Data]
  public var PDFAnnotations: [PDFAnnotation]
}
