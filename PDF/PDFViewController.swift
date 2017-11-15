//
//  PDFViewController.swift
//  PDF
//
//  Created by Vui Nguyen on 11/14/17.
//  Copyright © 2017 Minitex. All rights reserved.
//
import PSPDFKit
import UIKit

public class PDFViewController: UIViewController {



  override public func viewDidLoad() {
      super.viewDidLoad()

    PSPDFKit.setLicenseKey("ayMdJS9o1bNAIcD2RRW4EBCT8kIbBAMIQOzZ+AuONFXi3AiEMHRcpVB7tOLb0ocsbu2+EJopWzHGHWE5sYEW0yVGpQR7N18+pijQUCwd0mF9jVBARvqviQl0bNlF9neeMDJWC4M7PXkfUjshPo7d2AZcwQgq8L8v2yZEpqGgzUq8xJwBI/xjhi6gjoazNJ+XHad91vxcfF60mrYDh9mIRcgAIdnI5IHy4w7pYV6w5wx3KftFTMYbQki1h298jARu3sHhecN58Y2MjsxMvo8cDsIMBUbGr/uqI9+jydXOf/eHw+qdYxqszCjPV5myMvUyIYpYGWkVwx+APcN6Z4+58qh0qAxf9n+LuS6UtKft/4FvQE8R7hvqePFfPTuu77sIWVAWzpYaw8d+rpXkcPs7yGZTImjeaxy+IkJZP5+jYne/6zPp7mMO1ma634ErcP0H")
      // Do any additional setup after loading the view.
      view.backgroundColor = .blue
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
