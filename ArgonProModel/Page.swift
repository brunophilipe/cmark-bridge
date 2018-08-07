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
	public class Page: FrontMatterFile
	{
		let name: String

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

	public enum Node
	{
		case page(Page), directory(name: String, nodes: [Node])

		public var name: String
		{
			switch self
			{
			case .page(let page): return page.name
			case .directory(name: let name, _): return "\(name)/"
			}
		}

		public var isFile: Bool
		{
			switch self
			{
			case .page: return true
			default: return false
			}
		}

		public var isDirectory: Bool
		{
			switch self
			{
			case .directory: return true
			default: return false
			}
		}

		public var detailCount: Int
		{
			switch self
			{
			case .directory(_, let nodes): return nodes.count
			default: return 0
			}
		}
	}
}
