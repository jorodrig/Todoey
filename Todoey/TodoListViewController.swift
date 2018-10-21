//
//  ViewController.swift
//  Todoey
//
//  Created by Joseph on 10/20/18.
//  Copyright © 2018 Coconut Tech LLc. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    var itemArray = ["Find Me","Buy Eggs","Buy Milk"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    //MARK = Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    //MARK - TableVIew Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{  //if a cell is selected put checkmakr
            tableView.cellForRow(at: indexPath)?.accessoryType = .none        //if already has a checkmark, remove it

        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark   //if not already selected with checkmark, add checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)  // animates the cell selected so it is not solid gray

    }
    //MARK - ADD NEW ITEM
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField  = UITextField() // local var with local scope
        
        let alert = UIAlertController(title: "Add New Todey Item", message: "", preferredStyle: .alert)
        
        //what will happen once the user cliks the Add Item button on the alert popup

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            self.itemArray.append(textField.text!)
            self.tableView.reloadData()
            
        }
        
        //Note addTextField in closure limited in scope here
        alert.addTextField { (alertTextField ) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
}

