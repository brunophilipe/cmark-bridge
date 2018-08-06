//
//  VialConfig.swift
//  ArgonProModel
//
//  Created by Bruno Philipe on 8/5/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import Foundation

struct VialConfig: Codable
{
	/// The title of the website.
	var title: String

	/// A short description of the website. Good for SEO and for meta tags.
	var description: String

	/// The base URL of the website. Default value is "/", which means this website lives at the root of a domain.
	///
	/// If the website lives at the url "www.example.com/blog/", then the base URL is "/blog/".
	var baseUrl: String
}
