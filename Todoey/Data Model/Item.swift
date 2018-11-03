//
//  Item.swift
//  Todoey
//
//  Created by Joseph on 11/3/18.
//  Copyright © 2018 Coconut Tech LLc. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") //This is the inverse relationship to the Category class or entity.  See the Forward relationship in the Category Class.  Lin
    
}
