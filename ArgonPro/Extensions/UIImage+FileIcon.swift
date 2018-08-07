//
//  UIImage+FileIcon.swift
//  ArgonPro
//
//  Created by Bruno Philipe on 8/8/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import UIKit
import ArgonProModel

extension UIImage
{
	static func image(forFilename filename: String) -> UIImage
	{
		guard let ext = filename.lastExtension, let fileImage = UIImage(named: "file_\(ext)") else
		{
			return #imageLiteral(resourceName: "page.pdf")
		}

		return fileImage
	}
}
