//
//  Drink.swift
//  laostra
//
//  Created by Daniel Mejia on 05/10/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import Foundation

struct Drink : Decodable {
    var id : String
    var status : String
    var picture : String
    var name : String
    var nickname : String
    var category : CategoryDrink
    var price : Int
    var description : String
    var specifications : String
    var selected : Bool = false
    var quantity : Int = 0
}

struct CategoryDrink: Decodable {
    var name : String
    var nickname: String
    var order : Int
}
