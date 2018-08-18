//
//  PostsTableViewController.swift
//  ArgonPro
//
//  Created by Bruno Philipe on 8/16/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import UIKit
import ArgonModel
import GadgetKit

class PostsTableViewController: UITableViewController
{
	var isShowingDrafts: Bool = false
	
	public var posts: [FrontMatterFile]? = nil
	{
		didSet
		{
			// This property might be set before viewDidLoad is called. If that's the case, the table view will be
			// reloaded automatically.
			tableView?.reloadData()
		}
	}
	
	override func viewDidLoad()
	{
		super.viewDidLoad()

		tableView.register(UINib(nibName: "DraftTableViewCell", bundle: .main), forCellReuseIdentifier: "cell_draft")
		tableView.register(UINib(nibName: "PostTableViewCell", bundle: .main), forCellReuseIdentifier: "cell_post")
	}

	// MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int
	{
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return posts?.count ?? 0
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let cell: UITableViewCell

		// Configure the cell...
		if let post = posts?[indexPath.row] as? Vial.Post
		{
			cell = tableView.dequeueReusableCell(withIdentifier: "cell_post", for: indexPath)
			cell.imageView?.image = #imageLiteral(resourceName: "post.pdf")
			cell.imageView?.highlightedImage = #imageLiteral(resourceName: "post_selected.pdf")
			cell.textLabel?.text = post.title
			
			if let postCell = cell as? PostTableViewCell
			{
				postCell.dateLabel.text = DateFormatter.longDate.string(from: post.date)
			}
		}
		else if let draft = posts?[indexPath.row] as? Vial.Page
		{
			cell = tableView.dequeueReusableCell(withIdentifier: "cell_draft", for: indexPath)
			cell.imageView?.image = #imageLiteral(resourceName: "draft.pdf")
			cell.imageView?.highlightedImage = #imageLiteral(resourceName: "draft_selected.pdf")
			cell.textLabel?.text = draft.name
		}
		else
		{
			cell = UITableViewCell()
		}

		return cell
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
	{
		guard let post = posts?[indexPath.row] else
		{
			return
		}
		
		let codeEditorController = CodeEditorViewController()
		codeEditorController.loadViewIfNeeded()
		codeEditorController.editorView?.text = post.contents
		codeEditorController.title = (post as? Vial.Post)?.title ?? (post as? Vial.Page)?.name
		codeEditorController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
		codeEditorController.navigationItem.leftItemsSupplementBackButton = true

		showDetailViewController(ThemedNavigationController(rootViewController: codeEditorController),
								 sender: tableView.cellForRow(at: indexPath))
	}
}
