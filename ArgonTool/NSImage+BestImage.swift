//
//  NSImage+BestImage.swift
//  ArgonTool
//
//  Created by Bruno Philipe on 8/9/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import Cocoa

extension NSImage
{
	func bestImage(for size: CGSize) -> NSImage
	{
		if let imageRep = bestRepresentation(for: NSMakeRect(0, 0, size.width, size.height),
											 context: nil,
											 hints: nil)
		{
			let bestImage = NSImage(size: imageRep.size)
			bestImage.addRepresentation(imageRep)
			return bestImage
		}

		return self
	}
}
