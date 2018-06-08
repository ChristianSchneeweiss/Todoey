//
//  ViewController.swift
//  Todoey
//
//  Created by Christian Schneeweiss on 08.06.18.
//  Copyright © 2018 Christian Schneeweiss. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

	var items = [Item]()
	let defaults = UserDefaults.standard
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		let newItem = Item(name: "Find Mike")
		items.append(newItem)
		items.append(Item(name: "Buy Eggos"))
		items.append(Item(name: "Destroy Demorgorgon"))
		
		if let itemsOptional = defaults.array(forKey: "TodoListArray") as? [Item] {
			items = itemsOptional
		}
	}

	//MARK: TableView Datasource Methods
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let itemCell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
		itemCell.textLabel?.text = items[indexPath.row].title
		
		let item = items[indexPath.row]
		
		itemCell.accessoryType = item.done ? .checkmark : .none
		
		return itemCell
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	
	//MARK: TableView Delegate Methods
	
	fileprivate func toggleCheckmark(_ tableView: UITableView, _ indexPath: IndexPath) {
		items[indexPath.row].done = !items[indexPath.row].done
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		toggleCheckmark(tableView, indexPath)
		
		tableView.reloadData()
		
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	//MARK: Add new items
	
	@IBAction func addButtonPressed(_ sender: Any) {
		
		var textField = UITextField()
		
		let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
		
		let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
			//what will happen once the user clicks the add item Button on our UIAlert
			self.items.append(Item(name: textField.text!))
			
			self.defaults.set(self.items, forKey: "TodoListArray")
			self.tableView.reloadData()
		}
		
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Create new item"
			textField = alertTextField
		}
		
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}
	
}
