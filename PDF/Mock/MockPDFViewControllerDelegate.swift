//
//  MockPDFViewControllerDelegate.swift
//  PDF
//
//  Created by Vui Nguyen on 2/23/18.
//  Copyright © 2018 Minitex. All rights reserved.
//

import Foundation

class MockPDFViewControllerDelegate: PDFViewControllerDelegate {
  func userDidNavigate(page: Int) {
    print("in MockPDFViewControllerDelegate: userDidNavigate")
  }

  func saveBookmarks(pageNumbers: [UInt]) {
    print("in MockPDFViewControllerDelegate: saveBookmarks")
  }

  func saveAnnotations(annotationsData: [Data]) {
    print("in MockPDFViewControllerDelegate: saveAnnotations")
  }

  init() {
  }
}
