//
//  Order.swift
//  laostra
//
//  Created by Daniel Mejia on 26/11/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import Foundation

struct Order : Decodable {
    var id : String
    var orderNum : String
    var status : String
    var total : Int
    var ownerId : String
    var orderItems : [ OrderItem ]
}

struct OrderItem: Decodable {
    var id : String
    var name: String
    var picture : String
    var type : String
    var price : Int
    var quantity : Int
    var total : Int
    var specifications : String
}
