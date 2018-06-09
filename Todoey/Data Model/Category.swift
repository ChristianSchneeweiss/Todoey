//
//  Category.swift
//  Todoey
//
//  Created by Christian Schneeweiss on 09.06.18.
//  Copyright © 2018 Christian Schneeweiss. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
	@objc dynamic var name : String = ""
	@objc dynamic var colorInHex : String?
	let items = List<Item>()
}
