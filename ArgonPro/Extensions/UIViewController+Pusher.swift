//
//  UIViewController+Pusher.swift
//  ArgonPro
//
//  Created by Bruno Philipe on 8/13/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import UIKit

extension UIViewController
{
	/// Returns the view controller that pushed the receiver view controller into the current navigation view controller, if
	/// appropriate. Will return nil if there's no parent navigation controller, or if the receiver view controller is the root
	/// view controller in the parent navigation controller's stack.
	var pusherViewController: UIViewController?
	{
		guard
			let navigationController = self.navigationController,
			let index = navigationController.children.firstIndex(of: self)
		else
		{
			return nil
		}
		
		if index == 0
		{
			return nil
		}
		else
		{
			return navigationController.children[index - 1]
		}
	}
}
