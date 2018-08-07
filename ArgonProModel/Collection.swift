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
	public class Collection: Hashable, Equatable
	{
		/// The configuration object of this collection.
		var collectionConfig: CollectionConfig

		/// The entries in this collection.
		var collectionEntries: [Entry]

		/// Stores errors found while parsing entries in this collection.
		public private(set) var entryParseErrors: [String: Error] = [:]

		init(collectionWrapper: FileWrapper) throws
		{
			let jsonDecoder = JSONDecoder()

			guard
				let configFileWrapper = collectionWrapper.fileWrappers?[InternalNodes.config],
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

			if let entriesDirectoryWrapper = collectionWrapper.fileWrappers?[InternalNodes.entries],
				entriesDirectoryWrapper.isDirectory,
				let entriesWrappers = entriesDirectoryWrapper.fileWrappers
			{
				for entryWrapper in entriesWrappers
				{
					do
					{
						collectionEntries.append(try Entry(fileWrapper: entryWrapper.value))
					}
					catch
					{
						entryParseErrors[entryWrapper.key] = error
					}
				}
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

			var entryWrappers = [String: FileWrapper]()

			for entry in entries
			{
				entryWrappers[entry.slug] = try entry.write()
			}

			let configFileWrapper = FileWrapper(regularFileWithContents: configData)
			let entriesFileWrapper = FileWrapper(directoryWithFileWrappers: entryWrappers)

			return FileWrapper(directoryWithFileWrappers: [
				InternalNodes.config: configFileWrapper,
				InternalNodes.entries: entriesFileWrapper
			])
		}

		public class Entry: FrontMatterFile
		{
			/// A string used as the filename and also as the URL for this entry if it generates output.
			let slug: String

			override init(fileWrapper: FileWrapper) throws
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

			func write() throws -> FileWrapper
			{
				let contentString: String

				do
				{
					contentString = try self.contents.prepending(frontMatter: frontMatter)
				}
				catch
				{
					throw WriteErrors.malformedFrontMatter(error)
				}

				guard let contents = contentString.data(using: .utf8) else
				{
					throw WriteErrors.emptySerialization
				}

				return FileWrapper(regularFileWithContents: contents)
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
			case malformedFrontMatter(Error)
			case emptySerialization
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
