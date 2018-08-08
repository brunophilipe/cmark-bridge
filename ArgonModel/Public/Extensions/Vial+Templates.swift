//
//  Vial+Templates.swift
//  ArgonProModel
//
//  Created by Bruno Philipe on 8/7/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import Foundation

public extension Vial
{
	convenience init(blogTemplate name: String)
	{
		self.init(name: "My Blog", description: "ArgonPro Vial Template")
		add(collection: Collection(name: "Blog", producesOutput: true))
		add(node: Page.exampleHomepage)
	}
}
