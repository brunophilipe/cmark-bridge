//
//  Document.swift
//  ArgonPro
//
//  Created by Bruno Philipe on 8/5/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import UIKit
import ArgonProModel

class Document: UIDocument
{
	private var loadState: LoadState = .notLoaded

	var vial: Vial?
	{
		guard case .loaded(let bundle) = loadState else
		{
			return nil
		}

		return bundle
	}

    override func contents(forType typeName: String) throws -> Any
	{
        // Encode your document with an instance of NSData or NSFileWrapper
        return Data()
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws
	{
        // Load your document from contents
		guard typeName == Vial.vialUniformTypeIdentifier, let bundleWrapper = contents as? FileWrapper else
		{
			throw Errors.unsupportedFile
		}

		loadState = .loaded(try Vial(from: bundleWrapper))
    }

	private enum LoadState
	{
		case notLoaded
		case loaded(Vial)
	}

	enum Errors: Error
	{
		case unsupportedFile
	}
}

extension Document
{
	private static func newBundlesUrl() throws -> URL
	{
		let fileManager = FileManager.default
		let cachesDirectory = try fileManager.url(for: .cachesDirectory,
												  in: .userDomainMask,
												  appropriateFor: nil,
												  create: true).appendingPathComponent("Staging")

		try fileManager.createDirectory(at: cachesDirectory, withIntermediateDirectories: true, attributes: nil)

		return cachesDirectory
	}

	static func createEmptyBundle(with name: String) throws -> URL
	{
		let bundleUrl = try newBundlesUrl().appendingPathComponent("\(name).vial")
		try Vial(name: name).write(to: bundleUrl)

		return bundleUrl
	}
}

