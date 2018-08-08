//
//  FileWrapper+Initializers.swift
//  GadgetKit
//
//  Created by Bruno Philipe on 8/7/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import Foundation

public protocol FileWrapperCodable
{
	init(fileWrapper: FileWrapper) throws

	func write() throws -> FileWrapper
}

public extension Dictionary where Value == FileWrapper
{
	public func mapCodableFileWappers<T>(failedKeys: inout [Key: Error]) -> [T] where T: FileWrapperCodable
	{
		return compactMap
			{
				do
				{
					return try T(fileWrapper: $0.value)
				}
				catch
				{
					failedKeys[$0.key] = error
					return nil
				}
			}
	}
}

public extension Dictionary where Key == String, Value == FileWrapper
{
	public func mapCodableFileWappers<T>() -> [String: T] where T: FileWrapperCodable
	{
		var mappedResult = [String: T]()

		for (key, value) in self
		{
			do
			{
				mappedResult[key] = try T(fileWrapper: value)
			}
			catch
			{
				NSLog("Failed parsing file “\(key)”: \(error)")
			}
		}

		return mappedResult
	}
}

public extension Collection where Element: FileWrapperCodable
{
	public func writeFileWrappers<T>(mappingKey: (T) -> String) throws -> [String: FileWrapper] where T == Element
	{
		var fileWrappers = [String: FileWrapper]()

		for element in self
		{
			fileWrappers[mappingKey(element)] = try element.write()
		}

		return fileWrappers
	}
}

public extension FileWrapper
{
	/// Given the key for a child FileWrapper of the receiver, if that FileWrapper is a directory file wrapper,
	/// parses that FileWrapper's children FileWrappers as FileWrapperCodable objects.
	///
	/// - Parameters:
	///   - childWrapper: The key for a child file wrapper of the receiver file wrapper.
	///   - failedKeys: A map of FileWrappers keys that failed to initialize and the respective error.
	/// - Returns: A list of FileWrapperCodable objects that parsed successfully.
	public func mapCodableFileWappers<T>(fromChild childWrapper: String,
										 failedKeys: inout [String: Error]) -> [T]? where T: FileWrapperCodable
	{
		guard isDirectory, let directoryWrappers = fileWrappers?[childWrapper], directoryWrappers.isDirectory else
		{
			return nil
		}

		return directoryWrappers.fileWrappers?.mapCodableFileWappers(failedKeys: &failedKeys)
	}

	public func mapCodableFileWappers<T>(fromChild childWrapper: String) -> [String: T]? where T: FileWrapperCodable
	{
		guard isDirectory, let directoryWrappers = fileWrappers?[childWrapper], directoryWrappers.isDirectory else
		{
			return nil
		}

		return directoryWrappers.fileWrappers?.mapCodableFileWappers()
	}
}
