//
//  Node.swift
//  ArgonProModel
//
//  Created by Bruno Philipe on 8/7/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import Foundation

/// A node is any file present in the Vial package that is not part of the predefined Vial structure. They are
/// accessible through the `nodes` property of the Vial object.
public protocol VialNode: class
{
	var name: String { get set }
}

extension Vial
{
	/// A page is a file that renders to its own static page.
	public class Page: FrontMatterFile, VialNode
	{
		/// The name of the receiver page, including the extension.
		public var name: String

		required init(fileWrapper: FileWrapper) throws
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

	/// A directory simply contain other nodes.
	///
	/// Child nodes are rendered to a folder with the parent Directory name, and Directories can be nested.
	public class Directory: VialNode, FileWrapperCodable
	{
		/// The name of the receiver directory.
		public var name: String

		/// Th contents of the receiver directory.
		public private(set) var children: [VialNode]

		/// Creates a new directory with the given name and children.
		init(name: String, children: [VialNode] = [])
		{
			self.name = name
			self.children = children
		}

		required init(fileWrapper: FileWrapper) throws
		{
			guard fileWrapper.isDirectory else
			{
				throw LoadErrors.fileWrapperNotDirectory
			}

			guard let filename = fileWrapper.filename else
			{
				throw LoadErrors.unnamedFileWrapper
			}

			name = filename
			children = try [VialNode](fileWrapper: fileWrapper)
		}

		func write() throws -> FileWrapper
		{
			return FileWrapper(directoryWithFileWrappers: try children.writeFileWrappers())
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

		public enum LoadErrors: Error
		{
			case fileWrapperNotDirectory
			case unnamedFileWrapper
		}
	}
}

extension Array where Element == VialNode
{
	init(fileWrapper: FileWrapper, ignoreUsing: ((String) -> Bool)? = nil) throws
	{
		var nodes = [VialNode]()

		if fileWrapper.isDirectory, let fileWrappers = fileWrapper.fileWrappers
		{
			for (fileName, fileWrapper) in fileWrappers
			{
				// Check if we should ignore this file by checking its filename with the check callback.
				guard ignoreUsing == nil || ignoreUsing?(fileName) == false else
				{
					continue
				}

				if fileWrapper.isRegularFile
				{
					nodes.append(try Vial.Page(fileWrapper: fileWrapper))
				}
				else if fileWrapper.isDirectory
				{
					nodes.append(try Vial.Directory(fileWrapper: fileWrapper))
				}
			}
		}

		self.init(nodes)
	}

	func writeFileWrappers() throws -> [String: FileWrapper]
	{
		var fileWrappers = [String: FileWrapper]()

		for node in self.compactMap({ $0 as? (FileWrapperCodable & VialNode) })
		{
			fileWrappers[node.name] = try node.write()
		}

		return fileWrappers
	}
}
