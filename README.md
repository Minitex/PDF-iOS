# PDF-iOS

## Trying the Example App

Before running the Example App for the first time, run
> carthage bootstrap

To pull in every PSPDFKit framework update after that, run
> carthage update

1. Open `PDF.xcodeproj`.
2. Ensure the `PDFExample` target is selected.
3. Build and run as normal.

To integrate your app with the PDF-iOS module, take a look at:
PDFExample/ViewController.swift

In either the openPDF1 or openPDF2 functions, you will
(using openPDF1 as an example):

1. Get the title of the PDF book you want to open.

`let documentName = books![0].title`

2. Get the file handle for the PDF book to open.

`let fileURL = Bundle.main.url(forResource: documentName, withExtension: "pdf")!`

3. Instantiate the ViewController from the PDF module to render the PDF.

`let pdfViewController = PDFViewController(licenseKey: APIKeys.PDFLicenseKey, bookId: documentName, fileURL: fileURL, lastPageRead: UInt(books![0].lastPageRead), delegate: self)`

4. Push the ViewController onto the NavigationController stack so that it can be displayed.

`self.navigationController?.pushViewController(pdfViewController, animated: true)`


