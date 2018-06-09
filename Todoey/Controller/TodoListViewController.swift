//
//  ViewController.swift
//  Todoey
//
//  Created by Christian Schneeweiss on 08.06.18.
//  Copyright © 2018 Christian Schneeweiss. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

	var items : Results<Item>?
	let realm = try! Realm()
	@IBOutlet weak var searchBar: UISearchBar!
	
	var selectedCategory : Category? {
		didSet{
			loadItems()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		tableView.separatorStyle = .none
		}
	
	override func viewWillAppear(_ animated: Bool) {
		title = selectedCategory!.name
		updateNavBar(withHexCode: selectedCategory!.colorInHex!)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		updateNavBar(withHexCode: "1D9BF6")
	}
	
	//MARK: NavBar Setup
	
	func updateNavBar(withHexCode colorHex : String) {
		guard let navBar = navigationController?.navigationBar else { fatalError("NavBar is not created")}
		navBar.barTintColor = UIColor(hexString: colorHex)
		
		navBar.tintColor = UIColor.init(contrastingBlackOrWhiteColorOn: UIColor(hexString: colorHex), isFlat: true)
		navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.init(contrastingBlackOrWhiteColorOn: UIColor(hexString: colorHex), isFlat: true)]
		searchBar.barTintColor = UIColor(hexString: colorHex)
	}

	//MARK: TableView Datasource Methods
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let itemCell = super.tableView(tableView, cellForRowAt: indexPath)
		
		if let item = items?[indexPath.row] {
			itemCell.textLabel?.text = item.title
			itemCell.accessoryType = item.done ? .checkmark : .none
			
			if let color = UIColor(hexString: selectedCategory!.colorInHex)?.darken(byPercentage: CGFloat(Double(indexPath.row)/Double(items!.count))) {
				itemCell.backgroundColor = color
				itemCell.textLabel?.textColor = UIColor.init(contrastingBlackOrWhiteColorOn: color, isFlat: true)
			}
		}
		else {
			itemCell.textLabel?.text = "No Items added"
		}
		return itemCell
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items?.count ?? 1
	}
	
	//MARK: TableView Delegate Methods
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if let item = items?[indexPath.row] {
			do {
				try realm.write {
					item.done = !item.done
				}
			}
			catch {
				print("Error saving Done status, \(error)")
			}
		}
		
		tableView.reloadData()
		tableView.deselectRow(at: indexPath, animated: false)
	}
	
	//MARK: Add new items
	
	func loadItems() {		
		items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
		tableView.reloadData()
	}
	
	@IBAction func addButtonPressed(_ sender: Any) {
		
		var textField = UITextField()
		
		let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
		let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
			//what will happen once the user clicks the add item Button on our UIAlert
			
			if let currentCategory = self.selectedCategory {
				do {
					try self.realm.write {
						let newItem = Item()
						newItem.title = textField.text!
						newItem.dateCreated = Date()
						currentCategory.items.append(newItem)
					}
				}
				catch {
					print("Error while saving Items, \(error)")
				}
			}
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
	
	//MARK: Delete items
	
	override func updateModel(at indexPath: IndexPath) {
		if let itemToDelete = items?[indexPath.row] {
			do {
				try self.realm.write {
					self.realm.delete(itemToDelete)
				}
			}
			catch {
				print("Error while deleting Items, \(error)")
			}
		}
	}
}

//MARK: Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {

	//MARK: Search Bar Delegate Functions

	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
		tableView.reloadData()
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
