//
//  ViewController.swift
//  Todoey
//
//  Created by Dobril Atanasov on 13.08.19.
//  Copyright © 2019 Dobril Atansov. All rights reserved.
//

import UIKit
import CoreData

// When specifing that the class is UITableViewController & the Table View Controller ins chosen in the main storybord then all the delegates and declarations are unnecessary, they are assumed.
class TodoListViewController: UITableViewController {
// We are declaring an array of type Item, set in the Data Model
    var dummyItems = [Item]()
    

    
    //set a parameter for the UserDefault plist, where data can be saved
    let defaults = UserDefaults.standard
    
    // set an object that refers to the app delagate, so that we can attach the persistant container to the constant
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
       LoadItems()
        
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
        if dummyItems[indexPath.row].done == true {
            context.delete(dummyItems[indexPath.row])
            dummyItems.remove(at: indexPath.row)
        } else {
        //This euqlas the opposite of itself - this substitudes the if else statement.
       dummyItems[indexPath.row].done = !dummyItems[indexPath.row].done
        }
        SaveItems()
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
            } else {

                // create an object of type item from context which is the persistant container
                let newItem = Item(context: self.context)
                
                newItem.name = textField.text!
                newItem.done = false
                self.dummyItems.append(newItem)
                self.SaveItems()
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
    //MARK: Core Data Save & Load Methods
    func SaveItems(){
        //saves the values to a db
       
        do {
            try context.save()
        } catch{
            print ("Error encoding")
        }
        tableView.reloadData()
    }
    
    func LoadItems(with request : NSFetchRequest<Item> = Item.fetchRequest()){

        do{
        dummyItems = try context.fetch(request)
        } catch {
            print ("Error fetching the results \(error)")
        }
        tableView.reloadData()
    }
}

//MARK: - Search Bar Methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Set the request by specifing its type and from where it fetches data. Basically we set the request load it with filters and sorters and run it
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //Specify the querry, where %@ is the argument, [cd] makes it not case censitive
        let predicate = NSPredicate(format: "name MATCHES[cd] %@", searchBar.text!)
        //run the rquest
        request.predicate = predicate
        //Set sort discriptor, which is a query for sorting the data, here we sort by title
        let sortDiscriptor = NSSortDescriptor(key: "name", ascending: true)
        //run the sorting. It expects an array of sort discriptors, which can pass several sorting rules
        request.sortDescriptors = [sortDiscriptor]
        //actually fetch the data
        LoadItems(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //Set the request by specifing its type and from where it fetches data. Basically we set the request load it with filters and sorters and run it
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //Specify the querry, where %@ is the argument, [cd] makes it not case censitive
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        //run the rquest
        request.predicate = predicate
        //Set sort discriptor, which is a query for sorting the data, here we sort by title
        let sortDiscriptor = NSSortDescriptor(key: "name", ascending: true)
        //run the sorting. It expects an array of sort discriptors, which can pass several sorting rules
        request.sortDescriptors = [sortDiscriptor]
        //actually fetch the data
        LoadItems(with: request)
    }
}

