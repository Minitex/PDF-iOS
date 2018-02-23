//
//  MockData.swift
//  PDF
//
//  Created by Vui Nguyen on 2/23/18.
//  Copyright © 2018 Minitex. All rights reserved.
//

import Foundation

class MockData {
  static let lastPageRead: UInt = 0
  static let bookmarkPages: [UInt] = []
  static let annotationsData: [Data] = []

  static func documentURL() -> URL {
    let documentName = "DataModeling"
    //let fileURL = Bundle.main.url(forResource: documentName, withExtension: "pdf")!
    let fileURL = Bundle(identifier: "edu.umn.minitex.simplye.PDF")?.url(forResource: documentName, withExtension: "pdf")
    return fileURL!
  }
}
