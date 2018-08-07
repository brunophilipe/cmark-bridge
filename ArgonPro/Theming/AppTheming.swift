//
//  AppTheme.swift
//  Kodex
//
//  Created by Bruno Philipe on 13/12/17.
//  Copyright © 2017 Bruno Philipe. All rights reserved.
//

import UIKit

private let darkTheme = DarkTheme()
private let lightTheme = LightTheme()

/// AppTheming management class. Controls the theme used for the App UI.
class AppTheming: NSObject
{
	private var observations: [NSKeyValueObservation] = []

	/// The current app theme. Setting this member automatically informs the view tree it need to be updated.
	var currentMode: Mode
	{
		willSet
		{
			willChangeValue(for: \AppTheming.currentTint)
		}

		didSet
		{
			didChangeValue(for: \AppTheming.currentTint)

			if currentMode != oldValue
			{
				updateAppearance()
			}
		}
	}

	@objc dynamic var currentTint: UIColor
	{
		return currentMode.theme.tintColor
	}

	/// The shared instace of the AppTheming class.
	static let instance = AppTheming(initialMode: Preferences.instance.appUsesDarkMode ? .dark : .light)

	private init(initialMode: Mode)
	{
		currentMode = initialMode

		super.init()

		updateAppearance()

		// We ask the preferences object to inform us when the user changes the app theme.
		let themeObservation = Preferences.instance.observe(\Preferences.appUsesDarkMode)
		{
			[self] preferences, _ in self.currentMode = preferences.appUsesDarkMode ? .dark : .light
		}

		observations.append(themeObservation)
	}

	/// Broadcasts a notification regarding the current app theme change.
	func updateAppearance()
	{
		let theme = currentMode.theme

		UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1,
					   initialSpringVelocity: 0, options: [], animations:
		{
			NotificationCenter.default.post(name: ThemeChangedNotificationName, object: theme)
		}, completion: nil)
	}

	@objc enum Mode: Int
	{
		/// A light theme with dark text.
		case light

		/// A dark theme with light text.
		case dark

		var asNumber: NSNumber
		{
			return NSNumber(value: self.rawValue)
		}

		/// Returns an AppTheme instance representing this theme option.
		var theme: AppTheme
		{
			switch self
			{
			case .dark: return darkTheme
			case .light: return lightTheme
			}
		}
        
        var statusBarStyle: UIStatusBarStyle
        {
            switch self
            {
            case .dark: return .lightContent
            case .light: return .default
            }
        }
	}
}
