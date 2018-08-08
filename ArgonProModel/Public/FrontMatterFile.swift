//
//  FrontMatterFile.swift
//  ArgonProModel
//
//  Created by Bruno Philipe on 8/7/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import Foundation
import GadgetKit

public class FrontMatterFile: FileWrapperCodable
{
	/// The front matter contents found in the entry file.
	let frontMatter: [String: Any]

	/// The contents of the entry file. This is everything else after the front matter closing line (`---`).
	let contents: String

	required public init(fileWrapper: FileWrapper) throws
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

		self.contents = contents
	}

	init(frontMatter: [String: Any], contents: String)
	{
		self.frontMatter = frontMatter
		self.contents = contents
	}

	public func write() throws -> FileWrapper
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

	public enum LoadErrors: Error
	{
		case malformedFrontMatter(Error)
		case entryNotRegularFile(filename: String)
		case entryNotUTF8(filename: String)
	}

	public enum WriteErrors: Error
	{
		case malformedFrontMatter(Error)
		case emptySerialization
	}
}
