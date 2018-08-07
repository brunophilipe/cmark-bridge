//
//  Vial+Examples.swift
//  ArgonProModel
//
//  Created by Bruno Philipe on 8/7/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import Foundation

extension Vial.Collection.Entry
{
	static func example(for collectionName: String) -> Vial.Collection.Entry
	{
		let exampleEntryContents = "This is an example entry. You can edit its contents by writting aftr the last `---` line. You can add as many entries as you want to the front matter by adding a \"key: value\" pair between the first and second `---` lines. These values can be accessed from other places in your Vial."
		let exampleSlug = "1-example-entry.md"

		return Vial.Collection.Entry(frontMatter: ["title": "Example \(collectionName) entry"],
									 contents: exampleEntryContents,
									 slug: exampleSlug)
	}
}

extension Vial.Page
{
	static var exampleHomepage: Vial.Page
	{
		let contents = """
---
title: Home
slug: /index.html
---
# Welcome to your Argon website!

Using ArgonPro you will be able to easily create advanced static websites from your iPad or iPhone.

To edit this page, simple tap the "Homepage.md" item under the "Pages" title in the main view of your Vial.

You will notice that although the filename is "Homepage.md", this page was rendered to a file name "index.html". That's because in the front matter of the file, the key-pair "slug: /index.html" is present. This overrides the automatic filename conversion into slugs.
"""
		return Vial.Page(name: "Homepage.md", frontMatter: ["title": "Home"], contents: contents)
	}
}
