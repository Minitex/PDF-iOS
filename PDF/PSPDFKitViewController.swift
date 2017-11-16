//
//  PSPDFKitViewController.swift
//  PDF
//
//  Created by Vui Nguyen on 11/16/17.
//  Copyright © 2017 Minitex. All rights reserved.
//

import UIKit
import PSPDFKitUI
import PSPDFKit

class PSPDFKitViewController: PSPDFViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      delegate = self

      // set up the regular menu bar
      navigationItem.setRightBarButtonItems([thumbnailsButtonItem, outlineButtonItem, bookmarkButtonItem, searchButtonItem, annotationButtonItem, activityButtonItem, settingsButtonItem], animated: false)

      // set up the menu bar for when we're in thumbnail view, but do not include the document editing button
      navigationItem.setRightBarButtonItems([thumbnailsButtonItem], for: .thumbnails, animated: false)

  }

}

// MARK: PSPDFViewControllerDelegate
extension PSPDFKitViewController: PSPDFViewControllerDelegate {

  func pdfViewController(_ pdfController: PSPDFViewController, didConfigurePageView pageView: PSPDFPageView) {
    print("Page loaded: %@", pageView)
  }
}
