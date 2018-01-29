# PDF-iOS

## Trying the Example App

Before running the Example App for the first time, run
> carthage bootstrap

To pull in every PSPDFKit framework update after that, run
> carthage update

1. Open `PDF.xcodeproj`.
2. Ensure the `PDFExample` target is selected.
3. Build and run as normal.
4. If PDFExample was installed previously and you get a .plist error while trying to run it, you may have to uninstall the PDFExample app and reinstall it, to get the updated .plist file.

To integrate your app with the PDF-iOS module, take a look at:
PDFExample/ViewController.swift

In the openPDF function, you will:

1. Grab the Book object (which contains previously saved settings and/or metadata for a PDF book, if they exist) for the PDF book you want to open.

`let book: Book = books![bookIndex]`

2. Get the title of the PDF book you want to open.

`let documentName = book.title`

3. Make that title the soon to be currently open book.

`currentBook = documentName`

4. Get the file handle for the PDF book to open.

`let fileURL = Bundle.main.url(forResource: documentName, withExtension: "pdf")!`

5. Instantiate the ViewController from the PDF module to render the PDF.

`let pdfViewController = PDFViewController.init(...)`

6. Push the ViewController onto the NavigationController stack so that it can be displayed.

`self.navigationController?.pushViewController(pdfViewController, animated: true)`


