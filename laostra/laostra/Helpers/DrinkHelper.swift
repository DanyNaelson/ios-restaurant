//
//  DrinkHelper.swift
//  laostra
//
//  Created by Daniel Mejia on 05/10/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import Foundation
import SwiftyJSON

func createDrink(drink: JSON) -> Drink{
    let id = drink["_id"].string ?? ""
    let status = drink["status"].string ?? ""
    let picture = drink["picture"].string ?? ""
    let name = drink["name"].string ?? ""
    let nickname = drink["nickname"].string ?? ""
    let category = CategoryDrink(
        name: drink["category"]["name"].string ?? "",
        nickname: drink["category"]["nickname"].string ?? "",
        order: drink["category"]["order"].int ?? 0
    )
    let price = drink["price"].int ?? 0
    let description = drink["description"].string ?? ""
    let specifications = drink["specifications"].string ?? ""
    let drinkObject = Drink(id: id, status: status, picture: picture, name: name, nickname: nickname, category: category, price: price, description: description, specifications: specifications)
    
    return drinkObject
}

func getDrinkCategories(drinks: [Drink]) -> [String]{
    let onlyCategories = drinks.map { "\($0.category.order)" + "_" + $0.category.name }
    let orderedCategories = Array(Set(onlyCategories)).sorted()
    var categories: [String] = []
    for category in orderedCategories {
        let categoryString = String(category.split(separator: "_")[1])
        categories.append(categoryString)
    }

    return categories
}
