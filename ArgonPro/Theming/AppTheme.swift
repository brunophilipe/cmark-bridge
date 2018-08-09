//
//  AppTheme.swift
//  Kodex
//
//  Created by Bruno Philipe on 13/12/17.
//  Copyright © 2017 Bruno Philipe. All rights reserved.
//

import UIKit

@objc protocol AppTheme
{
	// MARK: Labels

	/// Color to be used in primary labels
	var text: UIColor { get }

	/// Color to be used as a control background color
	var controlBackground: UIColor { get }

	/// Color used as for controls that display placeholder text.
	var placeholderText: UIColor { get }

	// MARK: Navigation

	/// Style for navigation bars
	var navigationBarStyle: UIBarStyle { get }

	/// Whether navigation bars are transluscent
	var navigationBarTransluscent: Bool { get }

	/// Color for table view backgrounds
	var navigationViewBackground: UIColor { get }

	/// Style for navigation bar title labels
	var navigationBarTitle: UIColor { get }

	// MARK: Table Views

	/// Color for table view backgrounds
	var tableBackground: UIColor { get }

	/// Color for table view separators
	var tableSeparator: UIColor { get }

	/// Color for table view section titles
	var tableSectionIndex: UIColor { get }

	/// Color for table view section backgrounds
	var tableSectionBackground: UIColor { get }

	/// Color for table view cell text
	var tableCellText: UIColor { get }

	/// Color for table view cell text when the cell is selected
	var tableSelectedCellText: UIColor { get }

	/// Color for table view cell text
	var tableDetailCellText: UIColor { get }

	/// Color for table view cell background
	var tableCellBackground: UIColor { get }

	// MARK: Switch

	var switchOn: UIColor { get }

	// MARK: HUD

	/// Background color for HUD-styled views
	var hudBackground: UIColor { get }

	/// Background color for HUD-styled controls
	var hudControl: UIColor { get }

	/// Text color for HUD-styled views
	var hudText: UIColor { get }

	// MARK: Vibrancy

	/// Blur style used in visual effect views
	var vibrancyBlurStyle: UIBlurEffect.Style { get }

	/// The compatible keyboard appearance for this theme
	var keyboardAppearance: UIKeyboardAppearance { get }

	// MARK: Panels

	/// Color used in panel separators
	var panelSeparator: UIColor { get }

	/// Color used in panel backgrounds
	var panelBackground: UIColor { get }

	/// Color used in the background of panel-related controls
	var panelControlBackground: UIColor { get }
}

extension AppTheme
{
	/// The tint color for the theme.
	var tintColor: UIColor
	{
		return #colorLiteral(red: 0.7176470588, green: 0, blue: 1, alpha: 1)
	}
}

class DarkTheme: NSObject, AppTheme
{
	var text: UIColor { return .lightText }
	var placeholderText: UIColor { return #colorLiteral(red: 0.2785187943, green: 0.2785686486, blue: 0.2785125302, alpha: 1) }
	var controlBackground: UIColor { return #colorLiteral(red: 0.1098284498, green: 0.1097278222, blue: 0.1140929684, alpha: 1) }
	var navigationBarStyle: UIBarStyle { return .blackOpaque }
	var navigationBarTransluscent: Bool { return false }
	var navigationViewBackground: UIColor { return #colorLiteral(red: 0.1098284498, green: 0.1097278222, blue: 0.1140929684, alpha: 1) }
	var navigationBarTitle: UIColor { return .white }
	var tableBackground: UIColor { return #colorLiteral(red: 0.09018357843, green: 0.09020376951, blue: 0.09018104523, alpha: 1) }
	var tableSeparator: UIColor { return #colorLiteral(red: 0.1921356022, green: 0.1921699941, blue: 0.1921312809, alpha: 1) }
	var tableSectionIndex: UIColor { return #colorLiteral(red: 0.4276053905, green: 0.4270472527, blue: 0.4489079714, alpha: 1) }
	var tableSectionBackground: UIColor { return #colorLiteral(red: 0.09018357843, green: 0.09020376951, blue: 0.09018104523, alpha: 1) }
	var tableCellText: UIColor { return .white }
	var tableSelectedCellText: UIColor { return .white }
	var tableDetailCellText: UIColor { return .lightText }
	var tableCellBackground: UIColor { return #colorLiteral(red: 0.1098284498, green: 0.1097278222, blue: 0.1140929684, alpha: 1) }
	var switchOn: UIColor { return tintColor }
	var hudBackground: UIColor { return #colorLiteral(red: 0.1921356022, green: 0.1921699941, blue: 0.1921312809, alpha: 1) }
	var hudControl: UIColor { return #colorLiteral(red: 0.2785187943, green: 0.2785686486, blue: 0.2785125302, alpha: 1) }
	var hudText: UIColor { return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) }
	var vibrancyBlurStyle: UIBlurEffect.Style { return .dark }
	var keyboardAppearance: UIKeyboardAppearance { return .dark }
	var panelSeparator: UIColor { return tableSeparator }
	var panelBackground: UIColor { return tableBackground }
	var panelControlBackground: UIColor { return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) }
}

class LightTheme: NSObject, AppTheme
{
	var text: UIColor { return .darkText }
	var placeholderText: UIColor { return #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1) }
	var controlBackground: UIColor { return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) }
	var navigationBarStyle: UIBarStyle { return .default }
	var navigationBarTransluscent: Bool { return false }
	var navigationViewBackground: UIColor { return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) }
	var navigationBarTitle: UIColor { return .black }
	var tableBackground: UIColor { return #colorLiteral(red: 0.9679285884, green: 0.9679285884, blue: 0.9679285884, alpha: 1) }
	var tableSeparator: UIColor { return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) }
	var tableSectionIndex: UIColor { return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) }
	var tableSectionBackground: UIColor { return #colorLiteral(red: 0.9679285884, green: 0.9679285884, blue: 0.9679285884, alpha: 1) }
	var tableCellText: UIColor { return .black }
	var tableSelectedCellText: UIColor { return .white }
	var tableDetailCellText: UIColor { return .darkText }
	var tableCellBackground: UIColor { return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) }
	var switchOn: UIColor { return tintColor }
	var hudBackground: UIColor { return #colorLiteral(red: 0.8274509804, green: 0.8352941176, blue: 0.8509803922, alpha: 1) }
	var hudControl: UIColor { return #colorLiteral(red: 0.8803018928, green: 0.8803018928, blue: 0.8803018928, alpha: 1) }
	var hudText: UIColor { return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) }
	var vibrancyBlurStyle: UIBlurEffect.Style { return .light }
	var keyboardAppearance: UIKeyboardAppearance { return .light }
	var panelSeparator: UIColor { return tableSeparator }
	var panelBackground: UIColor { return tableBackground }
	var panelControlBackground: UIColor { return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) }
}
