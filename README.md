# PDF-iOS

## Trying the Example App

Before running the Example App for the first time, run
> carthage bootstrap

To pull in every PSPDFKit framework update after that, run
> carthage update

1. Run ./swiftlint-setup.sh to install a local copy of 
[SwiftLint](https://github.com/realm/SwiftLint)
2. Open `PDF.xcodeproj`.
3. Ensure that [MinitexPDFProtocols.framework](https://github.com/Minitex/MinitexPDFProtocols) is linked in the `PDF` target, and embedded and linked in the `PDFExample` target.
3. Ensure the `PDFExample` target is selected.
4. Build and run as normal.
5. If PDFExample was installed previously and you get a .plist error while trying to run it, you may have to uninstall the PDFExample app and reinstall it, to get the updated .plist file.

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

5. Build a dictionary of the attributes to pass into the PDFViewController / renderer.

`let pdfDictionary: [String: Any] =  ...`

6. Use the MinitexPDFViewControllerFactory to create a PDFViewController and pass the dictionary you built earlier into it.

`let pdfViewController = MinitexPDFViewControllerFactory.createPDFViewController(dictionary: pdfDictionary)`

7. Push the ViewController onto the NavigationController stack so that it can be displayed.

`self.navigationController?.pushViewController(pdfViewController, animated: true)`


