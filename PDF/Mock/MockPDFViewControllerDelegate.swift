//
//  MockPDFViewControllerDelegate.swift
//  PDF
//
//  Created by Vui Nguyen on 2/23/18.
//  Copyright © 2018 Minitex. All rights reserved.
//

import Foundation
import MinitexPDFProtocols

public protocol MockPDFViewControllerDelegateDelegate: class {
  func persistLastPageRead(page: Int)
  func persistBookmarks(pageNumbers: [UInt])
  func persistAnnotations(annotations: [MinitexPDFAnnotation])
}

class MockPDFViewControllerDelegate: MinitexPDFViewControllerDelegate {
  func willMoveToMinitexParentController(parent: UIViewController?) {
    print("in MockPDFViewControllerDelegate: willMoveToMinitexParentController")
  }

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

  func saveAnnotations(annotations: [MinitexPDFAnnotation]) {
    print("in MockPDFViewControllerDelegate: saveAnnotations(annotations)")
    mockPDFViewControllerDelegateDelegate?.persistAnnotations(annotations: annotations)
  }
}
