//
//  Categoty.swift
//  Todoey
//
//  Created by Dobril Atanasov on 4.09.19.
//  Copyright © 2019 Dobril Atansov. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var title : String = ""
    var items = List<Item>()
    
    
}
