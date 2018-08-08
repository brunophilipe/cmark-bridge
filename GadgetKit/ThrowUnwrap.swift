//
//  ThrowUnwrap.swift
//  GadgetKit
//
//  Created by Bruno Philipe on 8/9/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import Foundation

public func unwrap<T>(_ value: T?) throws -> T
{
	guard let unwrappedValue = value else
	{
		throw ThrowUnwrap.foundNil
	}

	return unwrappedValue
}

public enum ThrowUnwrap: Error
{
	case foundNil
}
