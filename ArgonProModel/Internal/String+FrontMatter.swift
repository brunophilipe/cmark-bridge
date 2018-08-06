//
//  String+FrontMatter.swift
//  ArgonProModel
//
//  Created by Bruno Philipe on 8/5/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import Foundation
import Yams

extension String
{
	mutating func extractFrontMatter() throws -> [String: Any]?
	{
		let frontMatterRegex = NSRegularExpression.frontMatterBoundary
		let string = self as NSString
		let frontMatterRange: NSRange
		var searchRange = NSMakeRange(0, string.length)

		let firstRange = frontMatterRegex.rangeOfFirstMatch(in: self, options: .withoutAnchoringBounds, range: searchRange)

		if firstRange.location == NSNotFound
		{
			// There is no front matter at all!
			return nil
		}

		searchRange = NSMakeRange(firstRange.upperBound, searchRange.length - firstRange.upperBound)
		let secondRange = frontMatterRegex.rangeOfFirstMatch(in: self, options: [], range: searchRange)

		if secondRange.location != NSNotFound
		{
			// The front matter is delimited both at the start and at the end
			frontMatterRange = NSMakeRange(firstRange.upperBound, secondRange.lowerBound - firstRange.upperBound)
		}
		else
		{
			// The front matter is only delimited at the end.
			frontMatterRange = NSMakeRange(0, firstRange.lowerBound)
		}

		let yamlString = string.substring(with: frontMatterRange)

		return try Yams.load(yaml: yamlString.trimmingCharacters(in: .whitespacesAndNewlines)) as? [String: Any]
	}

	func prepending(frontMatter: [String: Any]) throws -> String
	{
		return "---\n\(try Yams.dump(object: frontMatter))\n---\n\(self)"
	}
}
