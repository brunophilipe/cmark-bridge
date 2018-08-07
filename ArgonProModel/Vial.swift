//
//  Vial.swift
//  ArgonProModel
//
//  Created by Bruno Philipe on 8/5/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import Foundation

/// A Vial is the data structure of an Argon project. It organizes and provides I/O facilities for all the project's
/// configurations and source files.
public class Vial
{
	/// The configuration object of this vial.
	var vialConfig: VialConfig

	/// The collections in this vial.
	var vialCollections: [Collection]

	/// The pages in this vial.
	var vialNodes: [Node]

	/// Stores errors found while parsing collections in this vial.
	var vialCollectionParseErrors = [String: Error]()

	public init(from fileWrapper: FileWrapper) throws
	{
		let jsonDecoder = JSONDecoder()

		guard
			let childrenWrappers = fileWrapper.fileWrappers,
			let configFileWrapper = childrenWrappers[InternalNodes.config],
			let vialConfigContents = configFileWrapper.regularFileContents
		else
		{
			throw LoadErrors.vialMissingConfigFile
		}

		do
		{
			vialConfig = try jsonDecoder.decode(VialConfig.self, from: vialConfigContents)
		}
		catch
		{
			throw LoadErrors.malformedVial(error)
		}

		vialCollections = []

		if let collectionsDirectoryWrapper = childrenWrappers[InternalNodes.collections],
			collectionsDirectoryWrapper.isDirectory,
			let collectionWrappers = collectionsDirectoryWrapper.fileWrappers
		{
			for collectionWrapper in collectionWrappers
			{
				do
				{
					vialCollections.append(try Collection(collectionWrapper: collectionWrapper.value))
				}
				catch
				{
					vialCollectionParseErrors[collectionWrapper.key] = error
				}
			}
		}

		vialNodes = []
		vialNodes.append(contentsOf: try parseNodes(from: childrenWrappers, onRootLevel: true))
	}

	public init(name: String)
	{
		vialConfig = VialConfig(title: name, description: "My ArgonPro Vial", baseUrl: "/")
		vialCollections = [Collection(name: "Blog", producesOutput: true)]
		vialNodes = [.page(Page.exampleHomepage)]
	}

	public func write(to url: URL) throws
	{
		let configData: Data

		do
		{
			configData = try JSONEncoder().encode(vialConfig)
		}
		catch
		{
			throw WriteErrors.malformedConfigFile
		}

		var collectionFileWrappers = [String: FileWrapper]()

		for collection in vialCollections
		{
			collectionFileWrappers[collection.name] = try collection.write()
		}

		let configFileWrapper = FileWrapper(regularFileWithContents: configData)
		let collectionsFileWrapper = FileWrapper(directoryWithFileWrappers: collectionFileWrappers)

		let vialWrapper = FileWrapper(directoryWithFileWrappers: [
			InternalNodes.config: configFileWrapper,
			InternalNodes.collections: collectionsFileWrapper
		])

		do
		{
			try vialWrapper.write(to: url, options: [], originalContentsURL: nil)
		}
		catch
		{
			throw WriteErrors.io(error)
		}
	}

	private func parseNodes(from fileWrappers: [String: FileWrapper], onRootLevel: Bool = false) throws -> [Node]
	{
		var nodes = [Node]()

		for (fileName, fileWrapper) in fileWrappers
		{
			// We ignore files with internal node names if they're on the root level.
			guard !onRootLevel || !InternalNodes.isInternalNode(fileName) else
			{
				continue
			}

			if fileWrapper.isRegularFile
			{
				nodes.append(.page(try Page(fileWrapper: fileWrapper)))
			}
			else if fileWrapper.isDirectory, let childrenWrappers = fileWrapper.fileWrappers
			{
				nodes.append(.directory(name: fileName, nodes: try parseNodes(from: childrenWrappers)))
			}
		}

		return nodes
	}

	public enum LoadErrors: Error
	{
		case urlNotDirectory
		case malformedVial(Error)
		case vialMissingConfigFile
	}

	public enum WriteErrors: Error
	{
		case malformedConfigFile
		case io(Error)
	}

	struct InternalNodes
	{
		static let config = "config.json"
		static let collections = "collections"

		static func isInternalNode(_ node: String) -> Bool
		{
			return [config, collections].contains(node)
		}
	}
}

public extension Vial
{
	/// The UTI used to identify this vial type.
	static var vialUniformTypeIdentifier = "app.argonpro.vial"

	/// The title of the website.
	var title: String
	{
		get { return vialConfig.title }
		set { vialConfig.title = newValue }
	}

	/// A short description of the website. Good for SEO and for meta tags.
	var description: String
	{
		get { return vialConfig.description }
		set { vialConfig.description = newValue }
	}

	/// The base URL of the website. Default value is "/", which means this website lives at the root of a domain.
	///
	/// If the website lives at the url "www.example.com/blog/", then the base URL is "/blog/".
	var baseUrl: String
	{
		get { return vialConfig.baseUrl }
		set { vialConfig.baseUrl = newValue }
	}

	/// The collections of the receiver vial.
	var collections: [Collection]
	{
		return vialCollections
	}

	/// Adds a new collection to the receiver vial.
	func add(collection: Collection)
	{
		guard vialCollections.firstIndex(of: collection) == nil else
		{
			return
		}

		vialCollections.append(collection)
	}

	/// Removes a collection from the receiver vial.
	func remove(collection: Collection)
	{
		if let index = vialCollections.firstIndex(of: collection)
		{
			vialCollections.remove(at: index)
		}
	}

	/// The other files found in the receiver vial. These can be regular files (which will be compiled into pages), or
	/// subdirectories.
	var nodes: [Node]
	{
		return vialNodes
	}

	/// Adds a node under the given node level, if specified. If not, add under the root level
	func add(node: Node, under: Node? = nil)
	{

	}
}
