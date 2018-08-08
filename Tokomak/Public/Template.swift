//
//  Template.swift
//  Tokomak
//
//  Created by Bruno Philipe on 8/8/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import Foundation
import ArgonModel
import Yams
import GadgetKit

public class Template
{
	/// The template configuration.
	let templateConfig: TemplateConfig

	/// Layouts are used as the main structure of a page.
	let layouts: [String: FrontMatterFile]

	/// Includes are small snippets of reusable HTML code, such as headers, footers, menus, etc…
	let includes: [String: FrontMatterFile]

	/// Resources include stylesheets, scripts, fonts, images, and any other resources used to render the template.
	let resources: [String: [String: Data]]

	public init(fileWrapper: FileWrapper) throws
	{
		guard fileWrapper.isDirectory else
		{
			throw LoadError.notDirectory
		}

		let yamlDecoder = YAMLDecoder()

		guard
			let configFileData = fileWrapper.fileWrappers?[InternalNodes.config]?.regularFileContents,
			let configFileString = String(data: configFileData, encoding: .utf8)
		else
		{
			throw LoadError.malformedTemplate
		}

		do
		{
			self.templateConfig = try yamlDecoder.decode(TemplateConfig.self, from: configFileString)
		}
		catch
		{
			throw LoadError.malformedConfigFile(error)
		}

		layouts = fileWrapper.mapCodableFileWappers(fromChild: InternalNodes.layouts) ?? [:]
		includes = fileWrapper.mapCodableFileWappers(fromChild: InternalNodes.includes) ?? [:]

		guard let childrenWrappers = fileWrapper.fileWrappers else
		{
			self.resources = [:]
			return
		}

		var resources = type(of: self.resources).init()

		for (filename, childWrapper) in childrenWrappers
		{
			guard childWrapper.isDirectory, !InternalNodes.isInternalNode(filename) else
			{
				continue
			}

			resources[filename] = try fileWrapper.loadFiles(fileType: Data.self, directoryType: nil)
		}

		self.resources = resources
	}

	enum LoadError: Error
	{
		case notDirectory
		case emptyTemplate
		case malformedTemplate
		case malformedConfigFile(Error)
	}

	struct InternalNodes
	{
		static let config = "template.yml"
		static let layouts = "layouts"
		static let includes = "includes"

		static func isInternalNode(_ node: String) -> Bool
		{
			return [config, layouts, includes].contains(node)
		}
	}
}

public extension Template
{
	/// A user-presented name for the template.
	var name: String { return templateConfig.name }

	/// A short description of the template.
	var description: String  { return templateConfig.description }

	/// The author name.
	var author: String  { return templateConfig.author }

	/// A short list of keywords describing this template (eg: "dark", "light", "simple", "blog", "news", etc…)
	var keywords: [String]  { return templateConfig.keywords }
}
