//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Joseph on 10/29/18.
//  Copyright © 2018 Coconut Tech LLc. All rights reserved.
//

import UIKit
import CoreData


class CategoryViewController: UITableViewController {
    //var itemArray = ["Find Me","Buy Eggs","Buy Milk"]
    var categoryArray = [Category]()  //create instance of item class, here we use this instance as an array of Item objects by enclosing as [Items]
    // this is our data model
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Category.plist")
    //let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(dataFilePath)
        loadCategories()

    }
    
    
    //MARK: - TableView Data Source Methods  - CoreData Version
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]                                     //the current items beind worked on or selected by user
        cell.textLabel?.text = category.name
        //cell.accessoryType = Category.done ? .checkmark: .none                      //ternary operator: if cell accessory type has no checkmark, add it, else
        //set it to no checkmark.  Item is done is user selects it
        return cell
    }
    
    
    //MARK: - Data Manipulation Methods
    
    
    //MARK: -  Add New Categories

    @IBAction func addBUttonPressed(_ sender: UIBarButtonItem) {
        var textField  = UITextField() // local var with local scope
        
        let alert = UIAlertController(title: "Add New Todey Category", message: "", preferredStyle: .alert)
        

        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in            //START CLOSURE
            let newCategory = Category(context: self.context)                   //Remember Item here is a Coredata model class that has a Context
            
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory)
            self.saveCategories()
            
        }   //end closure
        
        //Note addTextField in closure limited in scope here
        alert.addTextField { (alertTextField ) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
        
        
    }
    //MARK = Model Manipulation methods
    func saveCategories(){
        
        //let encoder = PropertyListEncoder()
        do {
            try context.save()      //Recall context is the temporary Staging area BEFORE the it is committed to the Database or datamodel.
            
        }catch {
            print("error saving context \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    //MARK - Read data from database model
    //NOTE: loadCategories method syntax.  The 'with request' is a default param of type NSFetchRequest that returns an array from db Category
    func loadCategories(){   // = Category.fetchRequest() is default value to load everything from DB initilly
        let  request: NSFetchRequest<Category> = Category.fetchRequest() //var called request of type NSFetchRequest
        
        do{
            categoryArray = try context.fetch(request)          //store the request data into exiting categoryArray
            
        } catch {
            print("error fecthing data from contect \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    //MARK: - TableView Delegate Methods - NOTE: Delegate Methods here is what is needed to provide the action or outcome of what happens once the user selects a category which is to show the ToDoListViewController and any stored data for each category.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
        self.saveCategories()
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
       
    }
    
    //NOTE - this prepare delegate method is called BEFORE the performSegue method is called each time.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController //destinationVC is downcast as a ToDoListViewCtrl
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row] //indexPath here is the current Row of the Category that has been selected.  We need this in order to be able to query the Items for that category. Recall the Category <-> Item DB data model knows this relationship because we set it up at the start.
        }
    }
}
//MARK - END CATEGORYVIEWCONTROLLER CLASS  and BEGIN CATEGORYVIEWCONTROLLER EXTENSION

extension CategoryViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        //loadCategories(with: request)                //call with param
        loadCategories()                //call with param

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {         //count the number of chars entered by user, if none load all item in DB
            loadCategories()                         //load all item if user does nothing in searchbar
            DispatchQueue.main.async {          //causes the searchbar to run in foreground queue then dismisses in not used or user clears
                searchBar.resignFirstResponder()    //stops the searchbar from being the current feature being used by used
                //so releases the searchbar and hides the KB is it is open
            }
        }
        
    }
    
    
}
