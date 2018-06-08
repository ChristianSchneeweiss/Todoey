//
//  Item.swift
//  Todoey
//
//  Created by Christian Schneeweiss on 08.06.18.
//  Copyright © 2018 Christian Schneeweiss. All rights reserved.
//

import Foundation

class Item {
	var title : String = ""
	var done : Bool = false
	
	init(name : String) {
		title = name
	}
}
