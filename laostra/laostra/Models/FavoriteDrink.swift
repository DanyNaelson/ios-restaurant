//
//  FavoriteDrink.swift
//  laostra
//
//  Created by Daniel Mejia on 12/10/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import Foundation

struct FavoriteDrink : Decodable {
    var _id : String
    var picture : String
    var name : String
    var nickname : String
    var category : String
    var description : String
}
