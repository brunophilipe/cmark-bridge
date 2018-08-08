//
//  Data+FileWrapperCodable.swift
//  Tokamak
//
//  Created by Bruno Philipe on 8/8/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import Foundation
import GadgetKit

extension Data: FileWrapperCodable
{
	public init(fileWrapper: FileWrapper) throws
	{
		guard let data = fileWrapper.regularFileContents else
		{
			throw LoadErrors.emptyFile
		}

		self.init(referencing: data as NSData)
	}

	public func write() throws -> FileWrapper
	{
		return FileWrapper(regularFileWithContents: self)
	}

	public enum LoadErrors: Error
	{
		case emptyFile
	}
}
