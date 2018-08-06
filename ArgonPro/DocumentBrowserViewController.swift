//
//  DocumentBrowserViewController.swift
//  ArgonPro
//
//  Created by Bruno Philipe on 8/5/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import UIKit


class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate
{
    override func viewDidLoad()
	{
        super.viewDidLoad()
        
        delegate = self
        
        allowsDocumentCreation = true
        allowsPickingMultipleItems = false
        
        // Update the style of the UIDocumentBrowserViewController
		browserUserInterfaceStyle = .dark
		view.tintColor = #colorLiteral(red: 0.7176470588, green: 0, blue: 1, alpha: 1)

        // Specify the allowed content types of your application via the Info.plist.
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    // MARK: UIDocumentBrowserViewControllerDelegate
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController,
						 didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void)
	{
		let alert = UIAlertController(title: "Vial Name", message: "Insert a name for your new Argon Vial:", preferredStyle: .alert)
		alert.addTextField(configurationHandler: { $0.text = "Untitled" })
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in importHandler(nil, .none) })
		alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
			guard let bundleName = alert.textFields?.first?.text else
			{
				importHandler(nil, .none)
				return
			}

			do
			{
				importHandler(try Document.createEmptyBundle(with: bundleName), .move)
			}
			catch
			{
				importHandler(nil, .none)
			}
		}))

		present(alert, animated: true)
		{
			alert.textFields?.first?.selectAll(nil)
		}
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentURLs documentURLs: [URL])
	{
        guard let sourceURL = documentURLs.first else { return }
        
        // Present the Document View Controller for the first document that was picked.
        // If you support picking multiple items, make sure you handle them all.
        presentDocument(at: sourceURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController,
						 didImportDocumentAt sourceURL: URL,
						 toDestinationURL destinationURL: URL)
	{
        // Present the Document View Controller for the new newly created document
        presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController,
						 failedToImportDocumentAt documentURL: URL,
						 error: Error?)
	{
        // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
    }
    
    // MARK: Document Presentation
    
    func presentDocument(at documentURL: URL)
	{
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let documentViewController = storyBoard.instantiateViewController(withIdentifier: "DocumentViewController") as! DocumentViewController
        documentViewController.document = Document(fileURL: documentURL)
        
        present(documentViewController, animated: true, completion: nil)
    }


}

