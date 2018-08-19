//
//  DocumentViewController.swift
//  ArgonPro
//
//  Created by Bruno Philipe on 8/5/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import UIKit
import ArgonModel
import Tokamak
import CommonMark

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

					self?._compile()
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

	func _compile()
	{
		let tokamak = Tokamak(delegate: self, defaultConfig: DefaultConfiguration())
		try! tokamak.compile(vial: document!.vial!, vialUrl: document!.fileURL)
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
		if traitCollection.horizontalSizeClass == .regular
		{
			return splitViewController.displayMode == .allVisible ? .primaryHidden : .allVisible
		}
		else
		{
			return .automatic
		}
	}
}

extension DocumentViewController: TokamakDelegate
{
	func tokamak(_ tokamak: Tokamak, willSartCompiling: Vial)
	{

	}

	func tokamak(_ tokamak: Tokamak, producedWarning: Error, whileCompilingVial: Vial)
	{

	}

	func tokamak(_ tokamak: Tokamak, markupCompilerFor markup: Markup) -> MarkupCompiler?
	{
		switch markup
		{
		case .markdown:
			return CommonMark()

		default:
			return nil
		}
	}
}

class CommonMark: MarkupCompiler
{
	func compile(markup: String) -> String
	{
		return markdownToHtml(string: markup)
	}
}
