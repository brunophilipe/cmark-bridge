//
//  TextPreviewViewController.swift
//  ArgonPro
//
//  Created by Bruno Philipe on 8/13/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import UIKit

class TextPreviewViewController: UIViewController, FileWrapperPreviewer
{
	@IBOutlet weak var textView: UITextView!
	
	public private(set) var text: String? = nil
	{
		didSet
		{
			textView?.text = text
		}
	}
	
    override func viewDidLoad()
	{
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		textView.text = text
    }
	
	func setPreviewing(fileWrapper: FileWrapper)
	{
		guard fileWrapper.isRegularFile, let contents = fileWrapper.regularFileContents else
		{
			return
		}
		
		title = fileWrapper.filename
		text = String(data: contents, encoding: .utf8)
	}
}
