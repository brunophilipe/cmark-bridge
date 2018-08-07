//
//  VialViewController.swift
//  ArgonPro
//
//  Created by Bruno Philipe on 8/6/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import UIKit
import ArgonProModel

class VialViewController: UITableViewController
{
	var document: Document?
	{
		return documentViewController?.document
	}

    override func viewDidLoad()
	{
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

	@IBAction private func closeDocument(_ sender: Any?)
	{
		documentViewController?.closeDocumentViewController()
	}

	override func numberOfSections(in tableView: UITableView) -> Int
	{
		return 3
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
	{
		switch section
		{
		case 0:
			return "Vial"

		case 1:
			return "Collections"

		case 2:
			return "Pages"

		default:
			return nil
		}
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		switch section
		{
		case 0:
			return 3

		case 1:
			guard let vial = document?.vial else
			{
				return 0
			}

			return vial.collections.count + 1

		case 2:
			guard let vial = document?.vial else
			{
				return 0
			}

			return vial.nodes.count + 1

		default:
			return 0
		}
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		guard let vial = document?.vial else
		{
			return UITableViewCell()
		}

		let cell: UITableViewCell

		switch (indexPath.section, indexPath.row)
		{
		case (0, 0):
			cell = tableView.dequeueReusableCell(withIdentifier: "title_input", for: indexPath)
			if let inputCell = cell as? InputTableViewCell
			{
				inputCell.label?.text = "Title"
				inputCell.textField.text = vial.title
			}

		case (0, 1):
			cell = tableView.dequeueReusableCell(withIdentifier: "title_input", for: indexPath)
			if let inputCell = cell as? InputTableViewCell
			{
				inputCell.label?.text = "Description"
				inputCell.textField.text = vial.description
			}

		case (0, 2):
			cell = tableView.dequeueReusableCell(withIdentifier: "title_input", for: indexPath)
			if let inputCell = cell as? InputTableViewCell
			{
				inputCell.label?.text = "Base URL"
				inputCell.textField.text = vial.baseUrl
			}

		case (1, vial.collections.count):
			cell = tableView.dequeueReusableCell(withIdentifier: "title_icon_discl", for: indexPath)
			cell.textLabel?.text = "New Collection…"
			cell.imageView?.image = #imageLiteral(resourceName: "collection_new.pdf")

		case (1, let row):
			cell = tableView.dequeueReusableCell(withIdentifier: "rightdetail_icon_discl", for: indexPath)
			cell.textLabel?.text = vial.collections[row].name
			cell.imageView?.image = #imageLiteral(resourceName: "collection.pdf")
			cell.detailTextLabel?.text = vial.collections[row].entriesDescription

		case (2, vial.nodes.count):
			cell = tableView.dequeueReusableCell(withIdentifier: "title_icon_discl", for: indexPath)
			cell.textLabel?.text = "New…"
			cell.imageView?.image = #imageLiteral(resourceName: "page_new.pdf")

		case (2, let row):
			let node = vial.nodes[row]
			let reuseIdentifier = node.isDirectory ? "rightdetail_icon_discl" : "title_icon_discl"
			cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
			cell.textLabel?.text = node.name
			cell.imageView?.image = node.isFile ? #imageLiteral(resourceName: "page.pdf") : #imageLiteral(resourceName: "directory.pdf")

			if node.isDirectory
			{
				cell.detailTextLabel?.text = "\(node.detailCount) items"
			}

		default:
			cell = UITableViewCell()
		}

		return cell
	}
}

extension VialViewController: DocumentChildViewController
{
	func documentDidOpen()
	{
		title = document?.vial?.title ?? ""
		tableView.reloadData()
	}

	func documentWillClose()
	{

	}
}

extension Vial.Collection
{
	var entriesDescription: String
	{
		return entries.count == 1 ? "1 entry" : "\(entries.count) entries"
	}
}
