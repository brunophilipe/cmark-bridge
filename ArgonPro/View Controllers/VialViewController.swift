//
//  VialViewController.swift
//  ArgonPro
//
//  Created by Bruno Philipe on 8/6/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import UIKit
import ArgonModel

class VialViewController: FilesTableViewController
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
	
	override var urlForCurrentFileWrapper: URL?
	{
		return document?.fileURL
	}

	override var sectionForFileRows: Int
	{
		return Sections.files.rawValue
	}

	override func numberOfSections(in tableView: UITableView) -> Int
	{
		return 4
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
	{
		guard let section = Sections(rawValue: section) else
		{
			return nil
		}

		switch section
		{
		case .config:
			return "Vial"

		case .posts:
			return "Blog Posts"

		case .collections:
			return "Collections"

		case .files:
			return "Files"
		}
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		guard let vial = document?.vial, let section = Sections(rawValue: section) else
		{
			return 0
		}

		switch section
		{
		case .config:
			return 3

		case .posts:
			return vial.drafts.count > 0 ? 3 : 2

		case .collections:
			return vial.collections.count + 1

		case .files:
			return numberOfFileItems
		}
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		guard let vial = document?.vial, let section = Sections(rawValue: indexPath.section) else
		{
			return UITableViewCell()
		}

		let cell: UITableViewCell

		switch (section, indexPath.row)
		{
		case (.config, 0):
			cell = tableView.dequeueReusableCell(withIdentifier: "title_input", for: indexPath)
			if let inputCell = cell as? InputTableViewCell
			{
				inputCell.label?.text = "Title"
				inputCell.textField.text = vial.title
			}

		case (.config, 1):
			cell = tableView.dequeueReusableCell(withIdentifier: "title_input", for: indexPath)
			if let inputCell = cell as? InputTableViewCell
			{
				inputCell.label?.text = "Description"
				inputCell.textField.text = vial.description
			}

		case (.config, 2):
			cell = tableView.dequeueReusableCell(withIdentifier: "title_input", for: indexPath)
			if let inputCell = cell as? InputTableViewCell
			{
				inputCell.label?.text = "Base URL"
				inputCell.textField.text = vial.baseUrl
			}

		case (.posts, 0):
			cell = tableView.dequeueReusableCell(withIdentifier: "rightdetail_icon_discl", for: indexPath)
			cell.textLabel?.text = "Posts"
			cell.imageView?.image = #imageLiteral(resourceName: "post.pdf")
			cell.imageView?.highlightedImage = #imageLiteral(resourceName: "post_selected.pdf")
			cell.detailTextLabel?.text = "\(vial.posts.count)"

		case (.posts, 1) where vial.drafts.count > 0:
			cell = tableView.dequeueReusableCell(withIdentifier: "rightdetail_icon_discl", for: indexPath)
			cell.textLabel?.text = "Drafts"
			cell.imageView?.image = #imageLiteral(resourceName: "draft.pdf")
			cell.imageView?.highlightedImage = #imageLiteral(resourceName: "draft_selected.pdf")
			cell.detailTextLabel?.text = "\(vial.drafts.count)"

		case (.posts, _):
			cell = tableView.dequeueReusableCell(withIdentifier: "title_icon_discl", for: indexPath)
			cell.textLabel?.text = "New Post…"
			cell.imageView?.image = #imageLiteral(resourceName: "post_new.pdf")
			cell.imageView?.highlightedImage = #imageLiteral(resourceName: "new_selected.pdf")

		case (.collections, vial.collections.count):
			cell = tableView.dequeueReusableCell(withIdentifier: "title_icon_discl", for: indexPath)
			cell.textLabel?.text = "New Collection…"
			cell.imageView?.image = #imageLiteral(resourceName: "collection_new.pdf")
			cell.imageView?.highlightedImage = #imageLiteral(resourceName: "new_selected.pdf")

		case (.collections, let row):
			let collection = vial.collections[vial.collectionKeys[row]]
			cell = tableView.dequeueReusableCell(withIdentifier: "rightdetail_icon_discl", for: indexPath)
			cell.textLabel?.text = vial.collectionKeys[row]
			cell.imageView?.image = #imageLiteral(resourceName: "collection.pdf")
			cell.imageView?.highlightedImage = #imageLiteral(resourceName: "collection_selected.pdf")
			cell.detailTextLabel?.text = String(quantity: collection?.entries.count,
												singular: "entry", plural: "entries")

		case (.files, vial.nodes.count):
			cell = tableView.dequeueReusableCell(withIdentifier: "title_icon_discl", for: indexPath)
			cell.textLabel?.text = "New…"
			cell.imageView?.image = #imageLiteral(resourceName: "page_new.pdf")
			cell.imageView?.highlightedImage = #imageLiteral(resourceName: "new_selected.pdf")

		case (.files, let row):
			return super.dequeueTableViewCell(forFileWith: row)

		default:
			cell = UITableViewCell()
		}

		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		guard let vial = document?.vial, let section = Sections(rawValue: indexPath.section) else
		{
			return
		}
		
		switch (section, indexPath.row)
		{
		case (.posts, 0):
			let postsViewController = PostsTableViewController()
			postsViewController.posts = vial.posts.sorted(by: { $0.date > $1.date })
			show(postsViewController, sender: tableView.cellForRow(at: indexPath))
			
		case (.posts, 1) where vial.drafts.count > 0:
			let postsViewController = PostsTableViewController()
			postsViewController.posts = vial.drafts
			show(postsViewController, sender: tableView.cellForRow(at: indexPath))
			
		case (.posts, _):
			// TODO: Create new post
			break
			
		case (.collections, vial.collections.count):
			break
			
		case (.collections, let row):
			let collectionViewController = CollectionTableViewController()
			collectionViewController.collection = vial.collections[vial.sortedCollectionKeys[row]]!
			collectionViewController.title = vial.sortedCollectionKeys[row]
			show(collectionViewController, sender: tableView.cellForRow(at: indexPath))
		
		case (.files, let row):
			super.didSelectFile(with: row)

		default:
			tableView.deselectRow(at: indexPath, animated: true)
		}
	}

	private enum Sections: Int
	{
		case config, posts, collections, files
	}
}

extension VialViewController: DocumentChildViewController
{
	func documentDidOpen()
	{
		if let nodes = document?.vial?.nodes
		{
			fileWrapper = FileWrapper(directoryWithFileWrappers: nodes)
		}
		else
		{
			fileWrapper = nil
		}

		title = document?.vial?.title ?? ""
		tableView.reloadData()
	}

	func documentWillClose()
	{

	}
}
