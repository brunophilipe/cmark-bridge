//
//  String+Formats.swift
//  ArgonPro
//
//  Created by Bruno Philipe on 8/11/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import Foundation

extension String
{
	static let byteMultipliers = ["kB", "MB", "GB", "TB", "PB"]

	/// Given an amount of bytes, creates a string that describes that size with the most appropriate multiplier.
	///
	/// The supported multipliers are "kB", "MB", "GB", "TB", and "PB". The binary scale is used (1024).
	///
	/// - Parameter byteSize: The number of bytes.
	init(describingByteSize byteSize: Int)
	{
		let bytes = Float(byteSize)

		for (multiplier, label) in String.byteMultipliers.enumerated().reversed()
		{
			let scale = powf(1024, Float(multiplier + 1))

			if bytes > scale
			{
				let scaledBytes = bytes / scale

				// Pick amount of decimal places so that the strings width look consistent
				if scaledBytes > 99
				{
					// Show no decimal places
					self.init(String(format: "%.0f %@", scaledBytes, label))
				}
				else if scaledBytes > 9
				{
					// Show one decimal place
					self.init(String(format: "%.1f %@", scaledBytes, label))
				}
				else
				{
					// Show two decimal places
					self.init(String(format: "%.2f %@", scaledBytes, label))
				}

				return
			}
		}

		self.init("\(byteSize) bytes")
	}
}
