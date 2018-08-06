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
	public class Collection
	{
		/// The configuration object of this collection.
		var collectionConfig: CollectionConfig

		/// The entries in this collection.
		var entries: [Entry]

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

			entries = [Entry]()

			if let entriesDirectoryWrapper = collectionWrapper.fileWrappers?[InternalNodes.entries],
				entriesDirectoryWrapper.isDirectory,
				let entriesWrappers = entriesDirectoryWrapper.fileWrappers
			{
				for entryWrapper in entriesWrappers
				{
					do
					{
						entries.append(try Entry(fileWrapper: entryWrapper.value))
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
			self.collectionConfig = CollectionConfig(name: name, producesOutput: producesOutput)

			let exampleEntryContents = "This is an example entry. You can edit its contents by writting aftr the last `---` line. You can add as many entries as you want to the front matter by adding a \"key: value\" pair between the first and second `---` lines. These values can be accessed from other places in your Vial."
			let exampleSlug = "1-example-entry.md"
			let exampleEntry = Entry(frontMatter: ["title": "Example \(name) entry"],
									 contents: exampleEntryContents,
									 slug: exampleSlug)

			self.entries = [exampleEntry]
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

		class Entry
		{
			/// The front matter contents found in the entry file.
			let frontMatter: [String: Any]

			/// A string used as the filename and also as the URL for this entry if it generates output.
			let slug: String

			/// The contents of the entry file. This is everything else after the front matter closing line (`---`).
			let contents: String

			init(fileWrapper: FileWrapper) throws
			{
				let filename = fileWrapper.filename ?? "<unknown file name>"

				guard fileWrapper.isRegularFile, let contentsData = fileWrapper.regularFileContents else
				{
					throw LoadErrors.entryNotRegularFile(filename: filename)
				}

				guard var contents = String(data: contentsData, encoding: .utf8) else
				{
					throw LoadErrors.entryNotUTF8(filename: filename)
				}

				do
				{
					self.frontMatter = try contents.extractFrontMatter() ?? [:]
				}
				catch
				{
					throw LoadErrors.malformedFrontMatter(error)
				}

				guard let slug = fileWrapper.filename else
				{
					throw LoadErrors.unnamedEntry
				}

				self.contents = contents
				self.slug = slug
			}

			init(frontMatter: [String: Any], contents: String, slug: String)
			{
				self.frontMatter = frontMatter
				self.contents = contents
				self.slug = slug
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
			case malformedFrontMatter(Error)
			case entryNotRegularFile(filename: String)
			case entryNotUTF8(filename: String)
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

extension Vial.Collection
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
}
