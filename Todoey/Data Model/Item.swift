//
//  Items.swift
//  Todoey
//
//  Created by Dobril Atanasov on 4.09.19.
//  Copyright © 2019 Dobril Atansov. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var done : Bool = false
     var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
