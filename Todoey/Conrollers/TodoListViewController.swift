//
//  ViewController.swift
//  Todoey
//
//  Created by Dobril Atanasov on 13.08.19.
//  Copyright © 2019 Dobril Atansov. All rights reserved.
//

import UIKit

// When specifing that the class is UITableViewController & the Table View Controller ins chosen in the main storybord then all the delegates and declarations are unnecessary, they are assumed.
class TodoListViewController: UITableViewController {
// We are declaring an array of type Item, set in the Data Model
    var dummyItems = [Item]()
    
    //set a parameter for the UserDefault plist, where data can be saved
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.name = "iPhone"
        dummyItems.append(newItem)
        let newItem2 = Item()
        newItem2.name = "Mac"
        dummyItems.append(newItem2)
        let newItem3 = Item()
        newItem3.name = "Apple Watch"
        dummyItems.append(newItem3)
        
        
    }
    
    //MARK: Specify the necessary methods for the table view to show data
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dummyItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = item.name
        
        // check the done status and than put the correct accessory
        //Turnery operator >>>
        // value = condition ? valueIfTrue : value if False
        cell.accessoryType = item.done == true ? .checkmark : .none

        return cell
    }
    
    //MARK: Table View Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //This euqlas the opposite of itself - this substitudes the if else statement.
        dummyItems[indexPath.row].done = !dummyItems[indexPath.row].done
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
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
                print ("Empty string")
            } else {
                
                let newItem = Item()
                newItem.name = textField.text!
                self.dummyItems.append(newItem)
                
                //saves the values to a persistent plist
                self.defaults.set(self.dummyItems, forKey: "TodoListArray")
                self.tableView.reloadData()
            }
            
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
    
}

