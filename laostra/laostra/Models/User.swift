//
//  User.swift
//  laostra
//
//  Created by Daniel Mejia on 21/08/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import Foundation

struct User : Decodable {
    var id : String
    var email : String
    var zipCode : String
    var role : String
    var nickname : String
    var confirm : Bool
    var birthday : Date
    var cellPhone : String
    var gender : String
    var google : Bool
    var facebook : Bool
    var withEmail : Bool
    var photo : String
    var favoriteDrinks : [ FavoriteDrink ]
    var favoriteDishes : [ FavoriteDish ]
    var promotions : [ Promotion ]
}
