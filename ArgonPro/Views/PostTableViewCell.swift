//
//  PostTableViewCell.swift
//  ArgonPro
//
//  Created by Bruno Philipe on 8/16/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import UIKit

class PostTableViewCell: ThemedTableViewCell
{
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var iconView: UIImageView!
	@IBOutlet weak var dateLabel: UILabel!
	
	override var imageView: UIImageView?
	{
		return iconView
	}
	
	override var textLabel: UILabel?
	{
		return titleLabel
	}
}
