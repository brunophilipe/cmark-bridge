//
//  DropSourceImageView.swift
//  ArgonTool
//
//  Created by Bruno Philipe on 8/9/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import Cocoa

class DropSourceImageView: NSImageView
{
	private var backgroundLayer: CALayer! = nil

	public var sourceUrl: URL? = nil

	required init?(coder: NSCoder)
	{
		super.init(coder: coder)

		registerForDraggedTypes([.fileURL])
	}

	override func awakeFromNib()
	{
		super.awakeFromNib()

		if let layer = self.layer
		{
			let backgroundLayer = CALayer()
			backgroundLayer.frame = layer.bounds.insetBy(dx: 4, dy: 4)
			backgroundLayer.cornerRadius = 4.0
			layer.insertSublayer(backgroundLayer, at: 0)
			self.backgroundLayer = backgroundLayer
		}
	}

	override func prepareForDragOperation(_ draggingInfo: NSDraggingInfo) -> Bool
	{
		let pasteboard = draggingInfo.draggingPasteboard
		var isDirectory: ObjCBool = false

		guard let url = pasteboard.readObjects(forClasses: [NSURL.self], options: nil)?.first as? URL else
		{
			return false
		}

		return FileManager.default.fileExists(atPath: url.path, isDirectory: &isDirectory) && isDirectory.boolValue
	}

	override func draggingEntered(_ draggingInfo: NSDraggingInfo) -> NSDragOperation
	{
		backgroundLayer.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)

		return NSDragOperation.generic
	}

	override func draggingExited(_ draggingInfo: NSDraggingInfo?)
	{
		backgroundLayer.backgroundColor = .clear
	}

	override func draggingEnded(_ draggingInfo: NSDraggingInfo)
	{
		backgroundLayer.backgroundColor = .clear

		let pasteboard = draggingInfo.draggingPasteboard
		guard let url = pasteboard.readObjects(forClasses: [NSURL.self], options: nil)?.first as? URL else
		{
			return
		}

		sourceUrl = url

		image = NSWorkspace.shared.icon(forFile: url.path).bestImage(for: bounds.size)
	}
}
