//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Christian Schneeweiss on 09.06.18.
//  Copyright © 2018 Christian Schneeweiss. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
		
		tableView.rowHeight = 80.0
    }
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
		cell.delegate = self		
		return cell
	}
	
	
	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
		guard orientation == .right else { return nil }
		
		let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
			// handle action by updating model with deletion
			
			print("Delete Cell")
			self.updateModel(at: indexPath)			
		}
		
		// customize the action appearance
		deleteAction.image = UIImage(named: "delete")
		
		return [deleteAction]
	}
	
	func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
		var options = SwipeOptions()
		options.expansionStyle = .destructive
		return options
	}
	
	func updateModel(at indexPath : IndexPath) {
		//Update our Datamodel
		
	}

}
