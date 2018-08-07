//
//  Preferences.swift
//  ArgonPro
//
//  Created by Bruno Philipe on 8/6/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import Foundation

class Preferences: NSObject
{
	private static let suiteName = "group.app.argonpro.ArgonGroup"
	private static var sharedInstance: Preferences! = nil

	internal lazy var defaults = UserDefaults(suiteName: Preferences.suiteName) ?? .standard

	/// Initializer declared as private to avoid accidental creation of new instances.
	private override init()
	{
		super.init()
	}

	/// The shared instance of the Preferences class.
	@objc
	class var instance: Preferences
	{
		if sharedInstance == nil
		{
			sharedInstance = Preferences()
		}

		return sharedInstance
	}

	// Default helpers

	func number(forKey key: String) -> NSNumber?
	{
		return defaults.object(forKey: key) as? NSNumber
	}
}

extension Preferences // Available preferences
{
	/// Whether the app uses the dark or light theme.
	@objc dynamic var appUsesDarkMode: Bool
	{
		get { return number(forKey: #keyPath(appUsesDarkMode))?.boolValue ?? true }
		set { defaults.setValue(NSNumber(value: newValue), forKey: #keyPath(appUsesDarkMode)) }
	}
}
