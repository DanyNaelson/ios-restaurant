//
//  Dishes.swift
//  laostra
//
//  Created by Daniel Mejia on 06/08/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import Foundation

struct Dish : Decodable {
    var id : String
    var status : String
    var picture : String
    var name : String
    var nickname : String
    var category : CategoryDish
    var price : Int
    var description : String
    var selected : Bool = false
    var quantity : Int = 0
}

struct CategoryDish: Decodable {
    var name : String
    var nickname: String
    var order : Int
}
