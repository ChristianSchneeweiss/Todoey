//
//  ViewController.swift
//  Todoey
//
//  Created by Christian Schneeweiss on 08.06.18.
//  Copyright © 2018 Christian Schneeweiss. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

	let items = ["Find Mike", "Buy Eggos", "Destory Demogorgon"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	//MARK: TableView Datasource Methods
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let itemCell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
		itemCell.textLabel?.text = items[indexPath.row]
		
		return itemCell
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	
	//MARK: TableView Delegate Methods
	
	fileprivate func toggleCheckmark(_ tableView: UITableView, _ indexPath: IndexPath) {
		if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
			tableView.cellForRow(at: indexPath)?.accessoryType = .none
		}
		else {
			tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
		}
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		toggleCheckmark(tableView, indexPath)
		
		tableView.deselectRow(at: indexPath, animated: true)
		
		
	}
}
