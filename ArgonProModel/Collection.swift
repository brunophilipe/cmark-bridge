//
//  Collection.swift
//  ArgonProModel
//
//  Created by Bruno Philipe on 8/5/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import Foundation

extension Vial
{
	public class Collection: Hashable, Equatable, FileWrapperCodable
	{
		/// The configuration object of this collection.
		var collectionConfig: CollectionConfig

		/// The entries in this collection.
		var collectionEntries: [Entry]

		/// Stores errors found while parsing entries in this collection.
		public private(set) var entryParseErrors: [String: Error] = [:]

		required init(fileWrapper: FileWrapper) throws
		{
			let jsonDecoder = JSONDecoder()

			guard
				let configFileWrapper = fileWrapper.fileWrappers?[InternalNodes.config],
				let vialConfigContents = configFileWrapper.regularFileContents
			else
			{
				throw LoadErrors.collectionMissingConfigFile
			}

			do
			{
				self.collectionConfig = try jsonDecoder.decode(CollectionConfig.self, from: vialConfigContents)
			}
			catch
			{
				throw LoadErrors.malformedCollection(error)
			}

			collectionEntries = [Entry]()

			if let entries: [Entry] = fileWrapper.mapCodableFileWappers(fromChild: InternalNodes.entries,
																			  failedKeys: &entryParseErrors)
			{
				collectionEntries.append(contentsOf: entries)
			}
		}

		init(name: String, producesOutput: Bool)
		{
			self.collectionConfig = CollectionConfig(name: name, producesOutput: producesOutput, uuid: UUID())
			self.collectionEntries = [Entry.example(for: name)]
		}

		func write() throws -> FileWrapper
		{
			let configData: Data

			do
			{
				configData = try JSONEncoder().encode(collectionConfig)
			}
			catch
			{
				throw WriteErrors.malformedCollectionConfigFile
			}

			let entryFileWrappers = try entries.writeFileWrappers(mappingKey: { $0.slug })

			return FileWrapper(directoryWithFileWrappers: [
				InternalNodes.config: FileWrapper(regularFileWithContents: configData),
				InternalNodes.entries: FileWrapper(directoryWithFileWrappers: entryFileWrappers)
			])
		}

		public class Entry: FrontMatterFile
		{
			/// A string used as the filename and also as the URL for this entry if it generates output.
			let slug: String

			required init(fileWrapper: FileWrapper) throws
			{
				guard let slug = fileWrapper.filename else
				{
					throw Collection.LoadErrors.unnamedEntry
				}

				self.slug = slug

				try super.init(fileWrapper: fileWrapper)
			}

			init(frontMatter: [String: Any], contents: String, slug: String)
			{
				self.slug = slug
				super.init(frontMatter: frontMatter, contents: contents)
			}
		}

		enum LoadErrors: Error
		{
			case collectionMissingConfigFile
			case malformedCollection(Error)
			case unnamedEntry
		}

		enum WriteErrors: Error
		{
			case parentNotDirectory
			case malformedCollectionConfigFile
			case serializationError(Error)
		}

		struct InternalNodes
		{
			static let config = "config.json"
			static let entries = "entries"
		}
	}
}

public extension Vial.Collection
{
	/// The name of this collection.
	var name: String
	{
		get { return collectionConfig.name }
		set { collectionConfig.name = newValue }
	}

	/// Whether this collection generates files.
	var producesOutput: Bool
	{
		get { return collectionConfig.producesOutput }
		set { collectionConfig.producesOutput = newValue }
	}

	/// The entries in this collection.
	var entries: [Entry]
	{
		return collectionEntries
	}

	/// Adds an entry to a collection.
	func add(entry: Entry)
	{
		collectionEntries.append(entry)
	}
}

extension Vial.Collection
{
	public var hashValue: Int
	{
		return collectionConfig.uuid.hashValue
	}

	public static func ==(lhs: Vial.Collection, rhs: Vial.Collection) -> Bool
	{
		return lhs.collectionConfig.uuid == rhs.collectionConfig.uuid
	}
}
