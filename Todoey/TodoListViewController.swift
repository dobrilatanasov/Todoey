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

    let dummyItems = ["iPhone", "Revolut", "Mac"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: Specify the necessary methods for the table view to show data
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = dummyItems[indexPath.row]
        return cell
    }
    
    //MARK: Table View Delegate Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(dummyItems[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

