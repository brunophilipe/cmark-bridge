//
//  UIViewController+ContextBus.swift
//  Journal
//
//  Created by Bruno Philipe on 30/6/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import UIKit

@objc
extension UIViewController
{
	/// Asks the view controller to broadcast a context object down its tree of children view controllers.
	/// Override this method to listen to context messages, and make sure to call super at some point.
	@objc
	func broadcastContext(_ context: Any)
	{
		children.forEach({ $0.broadcastContext(context) })
	}
}
