//
//  DocumentViewController.swift
//  ArgonPro
//
//  Created by Bruno Philipe on 8/5/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import UIKit

class DocumentViewController: ThemedNavigationController
{
    var document: Document?
	{
		didSet
		{
			guard let document = self.document, oldValue == nil else
			{
				// baaaaaad
				return
			}

			// Access the document
			document.open()
			{
				[weak self] success in

				if success
				{
					self?.children.forEach({ ($0 as? DocumentChildViewController)?.documentDidOpen() })
				}
				else
				{
					// Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
				}
			}
		}
	}
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		splitViewController?.delegate = self
		splitViewController?.preferredDisplayMode = .allVisible
	}
    
    func closeDocumentViewController()
	{
		children.forEach({ ($0 as? DocumentChildViewController)?.documentWillClose() })

        dismiss(animated: true)
		{
            self.document?.close(completionHandler: nil)
        }
    }

	override func broadcastContext(_ context: Any)
	{
		super.broadcastContext(context)

		if let documentContext = context as? DocumentContext
		{
			document = documentContext.document
		}
	}

	struct DocumentContext
	{
		let document: Document
	}
}

extension UIViewController
{
	var documentViewController: DocumentViewController?
	{
		return parent as? DocumentViewController ?? parent?.documentViewController
	}
}

protocol DocumentChildViewController
{
	func documentDidOpen()
	func documentWillClose()
}

extension DocumentViewController: UISplitViewControllerDelegate
{
	func targetDisplayModeForAction(in splitViewController: UISplitViewController) -> UISplitViewController.DisplayMode
	{
		return splitViewController.displayMode == .allVisible ? .primaryHidden : .allVisible
	}
}
