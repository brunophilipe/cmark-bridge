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
	private var vialConfig: VialConfig

	/// The collections in this vial.
	public private(set) var collections: [Collection]

	/// Stores errors found while parsing collections in this vial.
	var collectionParseErrors = [String: Error]()

	public init(from fileWrapper: FileWrapper) throws
	{
		let jsonDecoder = JSONDecoder()

		guard
			let configFileWrapper = fileWrapper.fileWrappers?[InternalNodes.config],
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

		collections = []

		if let collectionsDirectoryWrapper = fileWrapper.fileWrappers?[InternalNodes.collections],
			collectionsDirectoryWrapper.isDirectory,
			let collectionWrappers = collectionsDirectoryWrapper.fileWrappers
		{
			for collectionWrapper in collectionWrappers
			{
				do
				{
					collections.append(try Collection(collectionWrapper: collectionWrapper.value))
				}
				catch
				{
					collectionParseErrors[collectionWrapper.key] = error
				}
			}
		}
	}

	public init(name: String)
	{
		vialConfig = VialConfig(title: name, description: "My ArgonPro Vial", baseUrl: "/")
		collections = [Collection(name: "Blog", producesOutput: true)]
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

		for collection in self.collections
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
}
