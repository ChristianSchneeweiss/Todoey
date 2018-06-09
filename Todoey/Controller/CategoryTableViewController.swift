//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Christian Schneeweiss on 09.06.18.
//  Copyright © 2018 Christian Schneeweiss. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

	var categories = [Category]()
	
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
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
		let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
		cell.textLabel?.text = categories[indexPath.row].name
		return cell
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return categories.count
	}
	
	//MARK: Data Manipulation Methods
	func saveCategories() {
		do {
			try context.save()
		}
		catch {
			print("Error while saving context, \(error)")
		}
		tableView.reloadData()
	}
	
	func loadCategories() {
		let request : NSFetchRequest<Category> = Category.fetchRequest()
		do {
			categories = try context.fetch(request)
		}
		catch {
			print("Error while loading context, \(error)")
		}
		tableView.reloadData()
	}
	

	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		var textfield = UITextField()
		
		let alert = UIAlertController(title: "Create new Category", message: "Create new Category", preferredStyle: .alert)
		let action = UIAlertAction(title: "Create", style: .default) { (action) in
			let newCategory = Category(context: self.context)
			newCategory.name = textfield.text!
			self.categories.append(newCategory)
			
			self.saveCategories()
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
				destinationVC.selectedCategory = categories[indexPath.row]
			}
		}
	}
	
	
}
