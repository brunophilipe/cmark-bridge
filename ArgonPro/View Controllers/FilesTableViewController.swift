//
//  FilesTableViewController.swift
//  ArgonPro
//
//  Created by Bruno Philipe on 8/11/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import UIKit

class FilesTableViewController: UITableViewController
{
	public var fileWrapper: FileWrapper? = nil
	{
		didSet
		{
			if let fileWrapperKeys = fileWrapper?.fileWrappers?.keys
			{
				itemKeys = Array(fileWrapperKeys).sortedNaturally()
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
