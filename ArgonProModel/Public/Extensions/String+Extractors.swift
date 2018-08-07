//
//  String+Extractors.swift
//  ArgonProModel
//
//  Created by Bruno Philipe on 8/7/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import Foundation

public extension String
{
	/// Returns the last extension in the string. For example: `md` for `home.md` and `gz` for `bundle.tar.gz`.
	var lastExtension: String?
	{
		if let lastPeriodIndex = lastIndex(of: "."), lastPeriodIndex != endIndex
		{
			return String(self[index(after: lastPeriodIndex)...])
		}

		return nil
	}
}
