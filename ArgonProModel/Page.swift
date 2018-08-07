//
//  Page.swift
//  ArgonProModel
//
//  Created by Bruno Philipe on 8/7/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import Foundation

extension Vial
{
	public class Page: FrontMatterFile, VialNode
	{
		/// The name of the receiver page, including the extension.
		public var name: String

		override init(fileWrapper: FileWrapper) throws
		{
			guard let name = fileWrapper.filename else
			{
				throw Collection.LoadErrors.unnamedEntry
			}

			self.name = name

			try super.init(fileWrapper: fileWrapper)
		}

		init(name: String, frontMatter: [String : Any], contents: String)
		{
			self.name = name
			super.init(frontMatter: frontMatter, contents: contents)
		}
	}

	public class Directory: VialNode
	{
		/// The name of the receiver directory.
		public var name: String

		/// Th contents of the receiver directory.
		public private(set) var children: [VialNode]

		init(name: String, children: [VialNode])
		{
			self.name = name
			self.children = children
		}

		/// Appends a child to the children set of the receiver directory.
		func add(child: VialNode)
		{
			children.append(child)
		}

		/// If the provided child is present in the children set of the receiver directory, removes it.
		func remove(child: VialNode)
		{
			if let index = children.firstIndex(where: { $0 === child })
			{
				children.remove(at: index)
			}
		}
	}
}
