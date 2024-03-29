//
//  ViewController.swift
//  Todoey
//
//  Created by Dobril Atanasov on 13.08.19.
//  Copyright © 2019 Dobril Atansov. All rights reserved.
//

import UIKit
import RealmSwift

// When specifing that the class is UITableViewController & the Table View Controller ins chosen in the main storybord then all the delegates and declarations are unnecessary, they are assumed.
class TodoListViewController: SwipeTableViewController {
// We are declaring an array of type Item, set in the Data Model
    var dummyItems : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            LoadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - Specify the necessary methods for the table view to show data
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = dummyItems?[indexPath.row]{
            cell.textLabel?.text = item.name
            // Turnery operator >>> value = condition ? valueIfTrue : value if False (heck the done status and than put the correct accessory)
            cell.accessoryType = item.done == true ? .checkmark : .none
            cell.backgroundColor = UIColor(hexString: dummyItems?[indexPath.row].itemCellColor  ?? "1D9BF6")
        } else {
            cell.textLabel?.text = "Add your first todoey..."
        }
        return cell
    }
    
   // MARK: - Table View Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = dummyItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print ("Error updating done proeperty!")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    //MARK: Add new items to the list
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //create a varible that is available through all the closures
        var textField = UITextField()
        //Create the alert controller and specify the title and the text of it
        let alert = UIAlertController(title: "New Todoey", message: "", preferredStyle: .alert)
        //Create the action - this adds the button at the bottom of the of the message

        let action = UIAlertAction(title: "Add", style: .default) { (action) in
           
            if textField.text! == "" {
                print ("User no input")
            } else {
                if let currentCategory = self.selectedCategory {
                    do{
                        try self.realm.write {
                            let newItem = Item()
                            newItem.name = textField.text!
                            newItem.dateCreated = Date()
                            newItem.itemCellColor = (UIColor.randomFlat()?.hexValue())!
                            //newItem.done = false is value by default
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print ("Error saving new item")
                    }
                }
            }
            self.tableView.reloadData()
        }
        //Specify the second button and its action
        let action2 = UIAlertAction(title: "Cancel", style: .default) { (action) in
            print("Cancelled")
        }
        //Adding a text field in the alert
        alert.addTextField { (alertTextField) in
            //Adding a placeholder inside
            alertTextField.placeholder = "What do you have to do?"
            //Getting it out of the closure
            textField = alertTextField
        }
        //Adding the action to the alert
        alert.addAction(action)
        alert.addAction(action2)
        //Showing the alert
        present(alert, animated: true,completion: nil)
        
    }
    //MARK: Core Data Save & Load Methods

    func LoadItems(){
        //Loading items for the selected category (parent)
        dummyItems = selectedCategory?.items.sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at IndexPath: IndexPath) {
        super.updateModel(at: IndexPath)
        if let swipedItem = self.dummyItems?[IndexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(swipedItem)
                }
            } catch {
                print ("Error deleting item!")
            }
        }
        
    }
}

        //MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        dummyItems = dummyItems?.filter("name MATCHES[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {
            LoadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            
        dummyItems = dummyItems?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        }
        tableView.reloadData()
    }
}

