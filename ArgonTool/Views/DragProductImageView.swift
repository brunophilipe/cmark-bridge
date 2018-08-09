//
//  DragProductImageView.swift
//  ArgonTool
//
//  Created by Bruno Philipe on 8/9/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import Cocoa
import CoreServices

class DragProductImageView: NSImageView
{
	var product: FileWrapper? = nil
	{
		didSet
		{
			let type = kUTTypePackage as String
			image = product != nil ? NSWorkspace.shared.icon(forFileType: type).bestImage(for: bounds.size) : nil
		}
	}

    override func draw(_ dirtyRect: NSRect)
	{
        super.draw(dirtyRect)

        // Drawing code here.
    }
}

extension DragProductImageView: NSDraggingSource
{
	func draggingSession(_ session: NSDraggingSession,
						 sourceOperationMaskFor context: NSDraggingContext) -> NSDragOperation
	{
		guard context == .outsideApplication, product != nil else
		{
			return []
		}

		return NSDragOperation.every
	}

	override func mouseDragged(with event: NSEvent)
	{
		super.mouseDragged(with: event)

		guard let image = self.image else
		{
			return
		}

		let draggingFrame = bounds

		let productProvider = NSFilePromiseProvider(fileType: "public.data", delegate: self)
		let draggingItem = NSDraggingItem(pasteboardWriter: productProvider)
		draggingItem.draggingFrame = draggingFrame
		draggingItem.imageComponentsProvider =
			{
				let icon = NSDraggingImageComponent(key: .icon)
				icon.contents = image
				icon.frame = draggingFrame

				return [icon]
			}

		beginDraggingSession(with: [draggingItem], event: event, source: self)
	}

}

extension DragProductImageView: NSFilePromiseProviderDelegate
{
	func filePromiseProvider(_ filePromiseProvider: NSFilePromiseProvider, fileNameForType fileType: String) -> String
	{
		return product!.filename!
	}

	func filePromiseProvider(_ filePromiseProvider: NSFilePromiseProvider,
							 writePromiseTo url: URL,
							 completionHandler: @escaping (Error?) -> Void)
	{
		do
		{
			try product?.write(to: url, options: [], originalContentsURL: nil)
			completionHandler(nil)
		}
		catch
		{
			completionHandler(error)
		}
	}
}
