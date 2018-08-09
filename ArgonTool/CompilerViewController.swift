//
//  CompilerViewController.swift
//  ArgonTool
//
//  Created by Bruno Philipe on 8/9/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import Cocoa
import Tokamak
import GadgetKit

class CompilerViewController: NSViewController
{
	@IBOutlet private weak var dropSourceView: DropSourceImageView!
	@IBOutlet private weak var dropProductView: DragProductImageView!
	@IBOutlet private weak var compileButton: NSButton!
	@IBOutlet private weak var compilationProgressIndicator: NSProgressIndicator!

    override func viewDidLoad()
	{
        super.viewDidLoad()
        // Do view setup here.
    }

	@IBAction private func compile(_ sender: Any?)
	{
		guard let themeUrl = dropSourceView.sourceUrl else
		{
			return
		}

		compilationProgressIndicator.startAnimation(sender)

		let productData: Data

		do
		{
			let template = try Template(fileWrapper: FileWrapper(url: themeUrl, options: .immediate))
			productData = try unwrap(try template.write().serializedRepresentation)
		}
		catch
		{
			NSAlert(error: error).runModal()
			compilationProgressIndicator.stopAnimation(sender)
			return
		}

		let packageFileWrapper = FileWrapper(regularFileWithContents: productData)
		packageFileWrapper.preferredFilename = themeUrl.lastPathComponent.appending(".tokamak")

		dropProductView.product = packageFileWrapper

		compilationProgressIndicator.stopAnimation(sender)
	}
}
