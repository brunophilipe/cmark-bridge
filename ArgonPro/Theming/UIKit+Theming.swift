//
//  UIKit+Theming.swift
//  Kodex
//
//  Created by Bruno Philipe on 14/12/17.
//  Copyright © 2017 Bruno Philipe. All rights reserved.
//

import UIKit

// MARK: - UISplitViewController

extension UISplitViewController
{
	func themeDidChange(_ theme: AppTheme)
	{
		view.backgroundColor = theme.splitViewBackground
		view.tintColor = theme.tintColor
		
		setNeedsStatusBarAppearanceUpdate()
	}
	
	open override var preferredStatusBarStyle: UIStatusBarStyle
	{
		return AppTheming.instance.currentMode == .dark ? .lightContent : .default
	}
}

class ThemedSplitViewController: UISplitViewController
{
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		registerForThemeChanges()
	}
}

// MARK: - UINavigationController

extension UINavigationController
{
	func themeDidChange(_ theme: AppTheme)
	{
		navigationBar.barStyle = theme.navigationBarStyle
		navigationBar.isTranslucent = theme.navigationBarTransluscent
		view.backgroundColor = theme.navigationViewBackground
        view.tintColor = theme.tintColor
	}
}

class ThemedNavigationController: UINavigationController
{
	override func viewDidLoad()
	{
		super.viewDidLoad()

		registerForThemeChanges()
	}
}

// MARK: - UITableView

extension UITableView
{
	func themeDidChange(_ theme: AppTheme)
	{
		backgroundColor = theme.tableBackground
		separatorColor = theme.tableSeparator
		sectionIndexColor = theme.tableSectionIndex
		sectionIndexBackgroundColor = theme.tableSectionBackground
		sectionIndexTrackingBackgroundColor = theme.tableSectionBackground
	}
}

class ThemedTableView: UITableView
{
	override func didMoveToWindow()
	{
		super.didMoveToWindow()

		registerForThemeChanges()
	}

	override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell
	{
		let cell = super.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
		cell.registerForThemeChanges()
		configureCell(cell, withCustomSelectionColor: tintColor)
		return cell
	}

	override func dequeueReusableCell(withIdentifier identifier: String) -> UITableViewCell?
	{
		let cell = super.dequeueReusableCell(withIdentifier: identifier)
		cell?.registerForThemeChanges()
		configureCell(cell, withCustomSelectionColor: tintColor)
		return cell
	}

	private func configureCell(_ cell: UITableViewCell?, withCustomSelectionColor color: UIColor)
	{
		guard let cell = cell else { return }

		if cell.selectionStyle == .none
		{
			cell.backgroundView?.removeFromSuperview()
		}
		else
		{
			cell.selectedBackgroundView = UIView()
			cell.selectedBackgroundView?.backgroundColor = color
		}
	}
}

// MARK: - UITableViewCell

extension UITableViewCell
{
	func themeDidChange(_ theme: AppTheme)
	{
		textLabel?.textColor = theme.tableCellText
		detailTextLabel?.textColor = theme.tableDetailCellText

		backgroundColor = theme.tableCellBackground
	}
}

class ThemedTableViewCell: UITableViewCell
{
	@IBOutlet var themedLabels: [UILabel]!

	override func themeDidChange(_ theme: AppTheme)
	{
		super.themeDidChange(theme)

		let textColor = theme.tableCellText
		themedLabels?.forEach({ $0.textColor = textColor })
	}

	override func setSelected(_ selected: Bool, animated: Bool)
	{
		super.setSelected(selected, animated: animated)

		let theme = AppTheming.instance.currentMode.theme
		let textColor = selected ? theme.tableSelectedCellText : theme.tableCellText
		themedLabels?.forEach({ $0.textColor = textColor })

		textLabel?.textColor = textColor
		detailTextLabel?.textColor = textColor
	}

	override func setHighlighted(_ highlighted: Bool, animated: Bool)
	{
		super.setHighlighted(highlighted, animated: animated)

		if !highlighted
		{
			return
		}

		let theme = AppTheming.instance.currentMode.theme
		let textColor = highlighted ? theme.tableSelectedCellText : theme.tableCellText
		themedLabels?.forEach({ $0.highlightedTextColor = textColor })

		textLabel?.highlightedTextColor = textColor
		detailTextLabel?.highlightedTextColor = textColor
	}
}

class HUDThemedTableViewCell: ThemedTableViewCell
{
	override func themeDidChange(_ theme: AppTheme)
	{
		super.themeDidChange(theme)

		backgroundColor = theme.hudBackground
	}
}

// MARK: - UISwitch

extension UISwitch
{
	func themeDidChange(_ theme: AppTheme)
	{
		onTintColor = theme.switchOn
	}
}

class ThemedSwitch: UISwitch
{
	override func didMoveToWindow()
	{
		super.didMoveToWindow()

		registerForThemeChanges()
	}
}
