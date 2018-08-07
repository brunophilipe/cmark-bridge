//
//  InputTableViewCell.swift
//  ArgonPro
//
//  Created by Bruno Philipe on 8/7/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import UIKit

class InputTableViewCell: ThemedTableViewCell
{
	@IBOutlet var label: UILabel!
	@IBOutlet var textField: UITextField!

	override func themeDidChange(_ theme: AppTheme)
	{
		super.themeDidChange(theme)

		textField.textColor = theme.text
	}
}
