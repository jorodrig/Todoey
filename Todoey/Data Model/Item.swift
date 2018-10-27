//
//  Item.swift
//  Todoey
//
//  Created by Joseph on 10/22/18.
//  Copyright © 2018 Coconut Tech LLc. All rights reserved.
//

import Foundation

class Item: Codable {   //Item class conforms to the Encodable and Decodable protocols (pre Swift 4) after Swift 4, simply use Codable.  These protocols are currently being used in the user defined plist
    //where the user data is currently being stored as persistent data as an array of Items


//class Item: Encodable, Decodable {   //Item class conforms to the Encodable and Decodable protocols.  These protocols are currently being used in the user defined plist
//                                    //where the user data is currently being stored as persistent data as an array of Items
    
    var title : String = ""
    var done : Bool = false
}
