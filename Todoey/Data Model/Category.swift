//
//  Category.swift
//  Todoey
//
//  Created by Joseph on 11/3/18.
//  Copyright © 2018 Coconut Tech LLc. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    //This is the data model in REALM DB. The relationships are done in code here whereby in this case the Category to Item tables or entities have a 1:n i.e. there are many items in a Category.  The inverse relationship of Items to Category is a N:1 and has to be coded in the Item class or entity.
    
    @objc dynamic var name : String = ""
    
    //The let items = List<Item>() line below defined the FORWARD RELATIONSHIP for the data model i.e. 1:n so each category has many items from this List.
    let items = List<Item>()            //create an empty  Realm List of Items.  Note there are other ways to initialize arrays as follows:   let items : array<Int> = [1,2,3]  or let array: [Int] = [1,2,3], or let array = [1,2,3] where the data type in the array is Inferred from the initialization values i.e .Ints.  Cannot mix data types in arrays.  Can also declare an array as an empty array as let array : [Int]() or let array : <Int>()
}

