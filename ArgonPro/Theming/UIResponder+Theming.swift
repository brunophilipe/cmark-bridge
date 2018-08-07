//
//  UIResponder+Theming.swift
//  Kodex
//
//  Created by Bruno Philipe on 13/12/17.
//  Copyright © 2017 Bruno Philipe. All rights reserved.
//

import UIKit

let ThemeChangedNotificationName = Notification.Name("ThemeChangedNotification")

@objc protocol Theming
{
	@objc optional func themeDidChange(_ theme: AppTheme)
}

private class ThemeNotifier: NSObject
{
	private let themeChangedBlock: (AppTheme) -> Void

	init(with block: @escaping (AppTheme) -> Void)
	{
		themeChangedBlock = block

		super.init()

		NotificationCenter.default.addObserver(forName: ThemeChangedNotificationName, object: nil, queue: nil)
		{
			[weak self] notification in

			if let theme = notification.object as? AppTheme
			{
				self?.themeChangedBlock(theme)
			}
		}
	}

	deinit
	{
		NotificationCenter.default.removeObserver(self)
	}
}

extension UIResponder: Theming
{
	func registerForThemeChanges()
	{
		guard objc_getAssociatedObject(self, "ThemeNotifier") == nil else
		{
			// Already registered
			return
		}

		objc_setAssociatedObject(self,
								 "ThemeNotifier",
								 ThemeNotifier(with: { [weak self] theme in (self as Theming?)?.themeDidChange?(theme) }),
								 objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)

		(self as Theming?)?.themeDidChange?(AppTheming.instance.currentMode.theme)
	}
}
