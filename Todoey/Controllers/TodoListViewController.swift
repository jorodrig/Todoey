//
//  ViewController.swift
//  Todoey
//
//  Created by Joseph on 10/20/18.
//  Copyright © 2018 Coconut Tech LLc. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    //var itemArray = ["Find Me","Buy Eggs","Buy Milk"]
    var itemArray = [Item]()  //create instance of item class, here we use this instance as an array of Item objects by enclosing as [Items]
                             // this is our data model
    var selectedCategory : Category? {  //Category is an optional datatype as it may not always have a value so initially can be nil
        didSet{         //didSet is a special feature that specifies when a var is set with a NEW value.  So everything between the Category? curly braces will only get set as SOON as selectedCategory gets sets in the prepare for seque method in the destination view controller which this time is CategoryViewController
            //loadItems()
        }
    }
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    //let defaults = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        //print(dataFilePath)
        

        //loadItems()          s//since no arg provided, will run with default param.  ALSO note: since we want to load items only after a category has been selected, we no longer need to call it here

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

//        context.delete(itemArray[indexPath.row])                              //This is how to remove data from both database and itemArray
//        itemArray.remove(at: indexPath.row)                                   //remove from itemArray.  MUST BE DONE <AFTER> contect.delete
        
        //The following line is test to update the data by updating the itemArray then commit with context.save()
        //itemArray[indexPath.row].setValue("Completed", forKey: "title")         //This is one way to update data.
        
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
//            let newItem = Item()
            // 10-27-2018: Note the following context var needs access to the project's AppDelegate which is a Class.
            //In order to get access to AppDelegate's persistentContainer property or method, the following code is needed as a Singleton.
            //let newItem = Item(context: self.context)                   //Remember Item here is a Coredata model class that has a Context
                                                                        //property which is now assigned to our appdelegate's context here
                                                                        //IMPORTANT: Item is of type NSManagedObject which IS-A ROW in our Entity
            //Entity here is the CoreData class, attributes are columns so NSManagedObject is a single row of data
            
//            newItem.title = textField.text!
//            newItem.done = false
//            newItem.parentCategory = self.selectedCategory
//            self.itemArray.append(newItem)
            
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
        
        //let encoder = PropertyListEncoder()
        do {
            try context.save()      //Recall context is the temporary Staging area BEFORE the it is committed to the Database or datamodel.
                
        }catch {
                print("error saving context \(error)")
            }

        self.tableView.reloadData()

    }
    //MARK - Read data from database model - COREDATA VERSION
    //NOTE: loadItems method syntax.  The 'with request' is a default param of type NSFetchRequest that returns an array from db Item
    //IMPORTANT NOTE: PREDICATE - predicates here is part of the SQL query on the DB that will only return results based on the predicate String that matches the criteria.  In this case, we want only the items that match the category in the DB.  Since we created a relationship between the two tables Items and Category. When we query the DB with multiple predicates or WHERE CLAUSE conditions, there is the risk only the last query will be retured on the DB results. So compund predicates or WHERE cluses will be needed since we want both Categories and their matching ITems, we actually query both tables that match the relationship.
//    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
//        // = Item.fetchRequest() is default value to load everything from DB initilly
//        //let request : NSFetchRequest<Item> = Item.fetchRequest()  // This will fecth all items in the database into request var
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//        //if let is optional binding to make sure we are not unwrapping a Nil value
//
//        if let additionalPredicate =  predicate{ //is Not Nil
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])            // additionalPridicate is unwrapped predicate that has been passed in if not nil
//        }else{
//            request.predicate = categoryPredicate           //if predicate passed in is NIL then just keep the selected category i.e. show the categories without items.
//        }
//
//        //request.predicate = compoundPredicate
//
//        do{
//            itemArray = try context.fetch(request)          //store the request data into exiting itemArray
//
//        } catch {
//            print("error fecthing data from contect \(error)")
//        }
//
//        tableView.reloadData()
//
//    }
    
    
    
}
    //MARK - END VIEWCONTROLLER CLASS  and BEGIN VIEWCONTROLLER EXTENSION

//extension TodoListViewController : UISearchBarDelegate {
//    // Happens when we press the Searchbar button or enter Key.  This creates a DB request on the Item DB that matches the predicate i.e. where condition clause for title, then we sort ascending and reload the sorted items.
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        let request : NSFetchRequest<Item> = Item.fetchRequest()  //fetch all data from Item DB
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)  // setup query string for only the item the user is searching for.
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)                //query items for only the Searched Item.
//
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {         //count the number of chars entered by user, if none load all item in DB
//            loadItems()                         //load all item if user does nothing in searchbar
//            DispatchQueue.main.async {          //causes the searchbar to run in foreground queue then dismisses in not used or user clears
//            searchBar.resignFirstResponder()    //stops the searchbar from being the current feature being used by used
//                                                //so releases the searchbar and hides the KB is it is open
//            }
//        }
//
//    }
//}

