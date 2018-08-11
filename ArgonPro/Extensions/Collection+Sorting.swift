//
//  Collection+Sorting.swift
//  ArgonPro
//
//  Created by Bruno Philipe on 8/11/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import Foundation

extension Collection where Element == String
{
	func sortedNaturally(ascending: Bool = true, caseInsensitive: Bool = true) -> [Element]
	{
		let comparator: ComparisonResult = ascending ? .orderedAscending : .orderedDescending

		if caseInsensitive
		{
			return sorted(by: { $0.localizedCaseInsensitiveCompare($1) == comparator })
		}
		else
		{
			return sorted(by: { $0.localizedCompare($1) == comparator })
		}
	}
}
