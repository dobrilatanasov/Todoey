//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Dobril Atanasov on 1.09.19.
//  Copyright © 2019 Dobril Atansov. All rights reserved.
//

import UIKit
import CoreData


class CategoryViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadCategories()
    }
    //MARK: Specify the necessary methods for the table view to show data
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let catDummy = categories[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = catDummy.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "New Category", message: "", preferredStyle: .alert)

        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            if textField.text! == "" {
            } else {
                let newCategory = Category(context: self.context)
                newCategory.title = textField.text!
                self.categories.append(newCategory)
                self.SaveCatgories()
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
    //MARK: - Core Data Save & Load Methods
    func SaveCatgories(){
        do {
            try context.save()
        } catch{
            print ("Error encoding")
        }
        tableView.reloadData()
    }
    
    func LoadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            categories = try context.fetch(request)
        } catch {
            print ("Error fetching the results \(error)")
        }
        tableView.reloadData()
    }
    
    
    
}
