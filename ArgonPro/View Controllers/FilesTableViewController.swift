//
//  FilesTableViewController.swift
//  ArgonPro
//
//  Created by Bruno Philipe on 8/11/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import UIKit
import QuickLook

class FilesTableViewController: UITableViewController
{
	public var fileWrapper: FileWrapper? = nil
	{
		didSet
		{
			if let fileWrapperKeys = fileWrapper?.fileWrappers?.keys
			{
				itemKeys = Array(fileWrapperKeys).filter({ !$0.hasPrefix(".") }).sortedNaturally()
			}
			else
			{
				itemKeys = nil
			}
		}
	}

	private var itemKeys: [String]? = nil
	{
		didSet
		{
			// This might be called before the views have loaded, therefore we use the safe unwrap operator here.
			// If that's the case, reloadData() will be called automtically after viewDidLoad().
			tableView?.reloadData()
		}
	}

	override func viewDidLoad()
	{
		super.viewDidLoad()

		// Uncomment the following line to preserve selection between presentations
		// self.clearsSelectionOnViewWillAppear = false

		// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
		// self.navigationItem.rightBarButtonItem = self.editButtonItem

		tableView.register(UINib(nibName: "FileTableViewCell", bundle: .main), forCellReuseIdentifier: "cell_file")
	}
	
	var urlForCurrentFileWrapper: URL?
	{
		guard
			let currentFilename = fileWrapper?.filename,
			let pusherViewController = pusherViewController as? FilesTableViewController
		else
		{
			return nil
		}
		
		return pusherViewController.urlForCurrentFileWrapper?.appendingPathComponent(currentFilename)
	}

	var numberOfFileItems: Int
	{
		return itemKeys?.count ?? 0
	}

	var sectionForFileRows: Int
	{
		return 0
	}

	func dequeueTableViewCell(forFileWith fileIndex: Int) -> UITableViewCell
	{
		guard let nodeKey = itemKeys?[fileIndex], let node = fileWrapper?.fileWrappers?[nodeKey] else
		{
			return UITableViewCell()
		}

		let indexPath = IndexPath(row: fileIndex, section: sectionForFileRows)
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell_file", for: indexPath)

		cell.textLabel?.text = node.filename
		cell.imageView?.image = node.isRegularFile ? UIImage.image(forFilename: node.filename) : #imageLiteral(resourceName: "directory.pdf")

		if node.isDirectory, let count = node.fileWrappers?.count
		{
			cell.detailTextLabel?.text = count == 1 ? "1 item" : "\(count) items"
			cell.accessoryType = .disclosureIndicator
		}
		else if node.isRegularFile, let bytes = node.fileAttributes[FileAttributeKey.size.rawValue] as? Int
		{
			cell.detailTextLabel?.text = String(describingByteSize: bytes)
			cell.accessoryType = .none
		}

		return cell
	}

	func didSelectFile(with fileIndex: Int)
	{
		guard let nodeKey = itemKeys?[fileIndex], let node = fileWrapper?.fileWrappers?[nodeKey] else
		{
			return
		}

		if node.isDirectory
		{
			let filesViewController = FilesTableViewController()
			filesViewController.fileWrapper = node
			filesViewController.title = node.filename

			let fileIndexPath = IndexPath(row: fileIndex, section: sectionForFileRows)
			show(filesViewController, sender: tableView.cellForRow(at: fileIndexPath))
		}
        else if node.isRegularFile
        {
			presentFile(for: node)
        }
	}
	
	func presentFile(for node: FileWrapper)
	{
		guard node.isRegularFile else
		{
			return
		}
		
		let fileWrapperPreviewer: UIViewController?
		
		if node.fileUTI(conformsTo: "public.image")
		{
			fileWrapperPreviewer = ImagePreviewViewController()
		}
		else if node.fileUTI(conformsTo: "com.adobe.pdf")
		{
			fileWrapperPreviewer = QLPreviewController(dataSource: self)
		}
		else if node.fileUTI(conformsTo: "public.text")
		{
			fileWrapperPreviewer = TextPreviewViewController()
		}
		else if let nodeFilename = node.filename,
			let nodeUrl = urlForCurrentFileWrapper?.appendingPathComponent(nodeFilename) as NSURL?,
			QLPreviewController.canPreview(nodeUrl)
		{
			fileWrapperPreviewer = QLPreviewController(dataSource: self)
		}
		else
		{
			// TODO: Show generic previewer
			fileWrapperPreviewer = nil
		}
		
		if let previewer = fileWrapperPreviewer as? FileWrapperPreviewer
		{
			previewer.setPreviewing(fileWrapper: node)
		}
		
		if let viewController = fileWrapperPreviewer
		{
			if splitViewController != nil
			{
				showDetailViewController(ThemedNavigationController(rootViewController: viewController), sender: self)
			}
			else
			{
				show(viewController, sender: self)
			}
		}
	}

	// MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int
	{
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return numberOfFileItems
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		return dequeueTableViewCell(forFileWith: indexPath.row)
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		if indexPath.section == sectionForFileRows
		{
			didSelectFile(with: indexPath.row)
		}
	}
}

extension FilesTableViewController: QLPreviewControllerDataSource
{
	func numberOfPreviewItems(in controller: QLPreviewController) -> Int
	{
		return tableView.indexPathsForSelectedRows?.count ?? 0
	}
	
	func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem
	{
		// Force unwraps are used here because this code path should only be accessible if everything unwrapped below
		// is properly setup.
		let selectedRows = tableView!.indexPathsForSelectedRows!
		let fileWrappers = fileWrapper!.fileWrappers!
		let nodeFilename = fileWrappers[itemKeys![selectedRows[index].row]]!.filename!
		return urlForCurrentFileWrapper!.appendingPathComponent(nodeFilename) as NSURL
	}
}

extension QLPreviewController
{
	convenience init(dataSource: QLPreviewControllerDataSource)
	{
		self.init()
		self.dataSource = dataSource
	}
}
