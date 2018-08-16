//
//  CollectionTableViewController.swift
//  ArgonPro
//
//  Created by Bruno Philipe on 8/16/18.
//  Copyright © 2018 Bruno Philipe. All rights reserved.
//

import UIKit
import ArgonModel

class CollectionTableViewController: UITableViewController
{
	public var collection: Vial.Collection? = nil
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
		
		tableView.register(UINib(nibName: "CollectionEntryTableViewCell", bundle: .main),
						   forCellReuseIdentifier: "cell_entry")
	}

	// MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int
	{
		return 1
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return collection?.entries.count ?? 0
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell_entry", for: indexPath)

		// Configure the cell...
		if let entry = collection?.entries[indexPath.row]
		{
			cell.textLabel?.text = entry.slug
			cell.imageView?.image = #imageLiteral(resourceName: "collection_entry.pdf")
		}

		return cell
	}
}
