//
//  ImagePreviewViewController.swift
//  ArgonPro
//
//  Created by Bruno Philipe on 8/13/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import UIKit

class ImagePreviewViewController: UIViewController
{
	@IBOutlet weak var imageView: UIImageView!
	
	public private(set) var image: UIImage? = nil
	{
		didSet
		{
			// This might get called before viewDidLoad. If that's the case, the image will be set from there instead.
			imageView?.image = image
		}
	}
	
    override func viewDidLoad()
	{
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		if let image = self.image
		{
			imageView.image = image
		}
    }
	
	override func viewDidLayoutSubviews()
	{
		super.viewDidLayoutSubviews()
		
		if let imageSize = image?.size,
			imageSize.width < imageView.frame.width && imageSize.height < imageView.frame.height,
			imageView.contentMode != .center
		{
			imageView.contentMode = .center
		}
		else if imageView.contentMode != .scaleAspectFit
		{
			imageView.contentMode = .scaleAspectFit
		}
	}

	func setImage(with fileWrapper: FileWrapper)
	{
		guard fileWrapper.isRegularFile, let contents = fileWrapper.regularFileContents else
		{
			return
		}
		
		if let filename = fileWrapper.filename
		{
			title = filename
			
			let extensionlessName = filename.removingLastExtension()
			
			if extensionlessName.hasSuffix("@3x")
			{
				image = UIImage(data: contents, scale: 3)
			}
			else if extensionlessName.hasSuffix("@2x")
			{
				image = UIImage(data: contents, scale: 2)
			}
			else
			{
				image = UIImage(data: contents)
			}
		}
		else
		{
			image = UIImage(data: contents)
		}
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
