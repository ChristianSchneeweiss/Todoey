//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Christian Schneeweiss on 09.06.18.
//  Copyright © 2018 Christian Schneeweiss. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: SwipeTableViewController {

	var categories: Results<Category>?
	
	let realm = try! Realm()
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
		
		loadCategories()				
    }
	
	//MARK: TableView Datasource Methods
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let cell = super.tableView(tableView, cellForRowAt: indexPath)

		
		cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added yet"
		return cell
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return categories?.count ?? 1
	}
	
	//MARK: Data Manipulation Methods
	func save(category: Category) {
		do {
			try realm.write {
				realm.add(category)
			}
		}
		catch {
			print("Error while saving context, \(error)")
		}
		tableView.reloadData()
	}
	
	override func updateModel(at indexPath: IndexPath) {
		if let categoryToDelete = self.categories?[indexPath.row] {
			do {
				try self.realm.write {
					self.realm.delete(categoryToDelete)
				}
			}
			catch {
				print("Error while deleting Item, \(error)")
			}
		}
	}
	
	func loadCategories() {
		categories = realm.objects(Category.self)
		
	}
	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		var textfield = UITextField()
		
		let alert = UIAlertController(title: "Create new Category", message: "Create new Category", preferredStyle: .alert)
		let action = UIAlertAction(title: "Create", style: .default) { (action) in
			let newCategory = Category()
			newCategory.name = textfield.text!
			
			self.save(category: newCategory)
		}
		
		alert.addAction(action)
		alert.addTextField { (categoryNameTextField) in
			categoryNameTextField.placeholder = "new Category"
			textfield = categoryNameTextField
		}
		
		present(alert, animated: true, completion: nil)
	}
	
	//MARK: TableView Delegate Methods
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "goToItems", sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "goToItems" {
			let destinationVC = segue.destination as! TodoListViewController
			
			if let indexPath = tableView.indexPathForSelectedRow {
				destinationVC.selectedCategory = categories?[indexPath.row]
			}
		}
	}
}



















