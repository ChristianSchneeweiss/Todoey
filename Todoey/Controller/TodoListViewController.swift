//
//  ViewController.swift
//  Todoey
//
//  Created by Christian Schneeweiss on 08.06.18.
//  Copyright © 2018 Christian Schneeweiss. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

	var items = [Item]()
	var selectedCategory : Category? {
		didSet{
			loadItems()
		}
	}
	
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
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
		
//		context.delete(items[indexPath.row])
//		items.remove(at: indexPath.row)
		
		toggleCheckmark(tableView, indexPath)
		saveItems()
		
		
		tableView.deselectRow(at: indexPath, animated: false)
	}
	
	//MARK: Add new items
	
	fileprivate func saveItems() {		
		do {
			try context.save()
		}
		catch {
			print("Error saving context, \(error)")
		}
		self.tableView.reloadData()
	}
	
	func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
		
		let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
		
		if let additionalPredicate = predicate {
			request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate, categoryPredicate])
		}
		else {
			request.predicate = categoryPredicate
		}
		
		do {
			items = try context.fetch(request)
		}
		catch {
			print("Error fetching data from context - \(error)")
		}
		tableView.reloadData()
	}
	
	@IBAction func addButtonPressed(_ sender: Any) {
		
		var textField = UITextField()
		
		let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
		let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
			//what will happen once the user clicks the add item Button on our UIAlert
			
			let newItem = Item(context: self.context)
			newItem.title = textField.text!
			newItem.done = false
			newItem.parentCategory = self.selectedCategory
			self.items.append(newItem)
			
			self.saveItems()
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

//MARK: Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {
	
	//MARK: Search Bar Delegate Functions
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		let request : NSFetchRequest<Item> = Item.fetchRequest()
		
		let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
		
		request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
		
		loadItems(with: request, predicate: predicate)
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchBar.text?.count == 0 {
			loadItems()
			
			DispatchQueue.main.async {
				searchBar.resignFirstResponder()
			}			
		}
	}
}
