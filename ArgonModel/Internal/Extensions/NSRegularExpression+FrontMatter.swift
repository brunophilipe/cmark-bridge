//
//  NSRegularExpression+FrontMatter.swift
//  ArgonProModel
//
//  Created by Bruno Philipe on 8/5/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import Foundation

extension NSRegularExpression
{
	static var frontMatterBoundary = try! NSRegularExpression(pattern: "^---$", options: .anchorsMatchLines)
}
