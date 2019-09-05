//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Dobril Atanasov on 1.09.19.
//  Copyright © 2019 Dobril Atansov. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryViewController: UITableViewController {
    var categories : Results<Category>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadCategories()
    }
    //MARK: Specify the necessary methods for the table view to show data
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].title ?? "Add your first category..."
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "New Category", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if textField.text! == "" {
            } else {
                let newCategory = Category()
                newCategory.title = textField.text!
                self.Save(object: newCategory)
            }
        }
        let action2 = UIAlertAction(title: "Cancel", style: .default) { (action) in
            print("Cancelled")
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Your new category"
            textField = alertTextField
        }
        alert.addAction(action)
        alert.addAction(action2)
        present(alert, animated: true,completion: nil)
        
        
    }
    //MARK: - Realm Save & Load Methods
    func Save(object: Category){
        do {
            try realm.write {
                realm.add(object)
            }
        } catch{
            print ("Error saving ro realm")
        }
        tableView.reloadData()
    }
    
    func LoadCategories(){
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    
    
}
