//
//  ViewController.swift
//  Todoey
//
//  Created by Joseph on 10/20/18.
//  Copyright © 2018 Coconut Tech LLc. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    //var itemArray = ["Find Me","Buy Eggs","Buy Milk"]
    var itemArray = [Item]()  //create instance of item class, here we use this instance as an array of Item objects by enclosing as [Items]
                             // this is our data model
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath)
        

        loadItems()

        // Do any additional setup after loading the view, typically from a nib.
//        if let items = UserDefaults.standard.array(forKey: "ToDoListArray") as? [String]  {
//            itemArray = items
//        }//User as! to cast as String
        
    }
    //MARK = Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]                                     //the current items beind worked on or selected by user
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark: .none                      //ternary operator: if cell accessory type has no checkmark, add it, else
                                                                                //set it to no checkmark.  Item is done is user selects it
        return cell
    }
    
    //MARK - TableVIew Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done          //sets the Done property each tableview row to the opposite of what it currently is
        self.saveItems()                                                        //if true set to false, if false set to true.  Replaces conditional If/else statements
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)

//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{  //if a cell is selected put checkmakr
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none        //if already has a checkmark, remove it
//
//        }else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark   //if not already selected with checkmark, add checkmark
//        }
//        tableView.deselectRow(at: indexPath, animated: true)  // animates the cell selected so it is not solid gray

    }
    //MARK - ADD NEW ITEM
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField  = UITextField() // local var with local scope
        
        let alert = UIAlertController(title: "Add New Todey Item", message: "", preferredStyle: .alert)
        
        //what will happen once the user cliks the Add Item button on the alert popup

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            self.saveItems()
            //self.defaults.set(self.itemArray, forKey: "ToDoListArray")  //is a dict key value
            
//            let encoder = PropertyListEncoder()
//            do {
//
//                let data = try encoder.encode(self.itemArray)
//                try data.write(to: self.dataFilePath!)
//            }catch{
//                print("error encoding tiem array, \(error)")
//
//            }
            
            //self.tableView.reloadData()
            
        }
        
        //Note addTextField in closure limited in scope here
        alert.addTextField { (alertTextField ) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    
    //MARK = Model Manipulation methods
    func saveItems(){
        
        let encoder = PropertyListEncoder()
        do {
            
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("error encoding tiem array, \(error)")
            
        }
        self.tableView.reloadData()

    }
    func loadItems(){
        
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            }catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
    
    
}

