//
//  FileWrapper+FileLoader.swift
//  GadgetKit
//
//  Created by Bruno Philipe on 8/8/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import Foundation

public extension FileWrapper
{
	func loadFiles<R>(fileType: FileWrapperCodable.Type?,
					  directoryType: FileWrapperCodable.Type?,
					  ignoreUsing: ((String) -> Bool)? = nil) throws -> [String: R]
	{
		var files: [String: R] = [:]

		if isDirectory, let fileWrappers = fileWrappers
		{
			for (filename, fileWrapper) in fileWrappers
			{
				// Check if we should ignore this file by checking its filename with the check callback.
				guard ignoreUsing == nil || ignoreUsing?(filename) == false else
				{
					continue
				}

				if fileWrapper.isRegularFile, let file = try fileType?.init(fileWrapper: fileWrapper) as? R
				{
					files[filename] = file
				}
				else if fileWrapper.isDirectory, let directory = try directoryType?.init(fileWrapper: fileWrapper) as? R
				{
					files[filename] = directory
				}
				else
				{
					NSLog("Found element that's neither flagged as directory or as file: \(filename)")
				}
			}
		}

		return files
	}
}
