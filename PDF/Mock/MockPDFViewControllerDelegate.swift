//
//  MockPDFViewControllerDelegate.swift
//  PDF
//
//  Created by Vui Nguyen on 2/23/18.
//  Copyright © 2018 Minitex. All rights reserved.
//

import Foundation

public protocol MockPDFViewControllerDelegateDelegate: class {
  func persistLastPageRead(page: Int)
  func persistBookmarks(pageNumbers: [UInt])
  func persistAnnotations(annotationsData: [Data])
  func persistAnnotations(annotations: [PDFAnnotation])
}

class MockPDFViewControllerDelegate: PDFViewControllerDelegate {
  weak var mockPDFViewControllerDelegateDelegate: MockPDFViewControllerDelegateDelegate?

  init(mockPDFViewControllerDelegateDelegate: MockPDFViewControllerDelegateDelegate) {
    self.mockPDFViewControllerDelegateDelegate = mockPDFViewControllerDelegateDelegate
  }

  func userDidNavigate(page: Int) {
    print("in MockPDFViewControllerDelegate: userDidNavigate")
    mockPDFViewControllerDelegateDelegate?.persistLastPageRead(page: page)
  }

  func saveBookmarks(pageNumbers: [UInt]) {
    print("in MockPDFViewControllerDelegate: saveBookmarks")
    mockPDFViewControllerDelegateDelegate?.persistBookmarks(pageNumbers: pageNumbers)
  }

  func saveAnnotations(annotationsData: [Data]) {
    print("in MockPDFViewControllerDelegate: saveAnnotations(annotationsData)")
    mockPDFViewControllerDelegateDelegate?.persistAnnotations(annotationsData: annotationsData)
  }

  func saveAnnotations(annotations: [PDFAnnotation]) {
    print("in MockPDFViewControllerDelegate: saveAnnotations(annotations)")
    mockPDFViewControllerDelegateDelegate?.persistAnnotations(annotations: annotations)
  }
}
