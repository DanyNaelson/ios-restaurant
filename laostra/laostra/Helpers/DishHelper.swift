//
//  DishHelper.swift
//  laostra
//
//  Created by Daniel Mejia on 07/08/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import Foundation
import SwiftyJSON

func createDish(dish: JSON) -> Dish{
    let id = dish["_id"].string ?? ""
    let status = dish["status"].string ?? ""
    let picture = dish["picture"].string ?? ""
    let name = dish["name"].string ?? ""
    let nickname = dish["nickname"].string ?? ""
    let category = CategoryDish(
        name: dish["category"]["name"].string ?? "",
        nickname: dish["category"]["nickname"].string ?? "",
        order: dish["category"]["order"].int ?? 0
    )
    let price = dish["price"].int ?? 0
    let description = dish["description"].string ?? ""
    let dishObject = Dish(id: id, status: status, picture: picture, name: name, nickname: nickname, category: category, price: price, description: description)
    
    return dishObject
}

func getDishCategories(dishes: [Dish]) -> [String]{
    let onlyCategories = dishes.map { "\($0.category.order)" + "_" + $0.category.name }
    let orderedCategories = Array(Set(onlyCategories)).sorted()
    var categories: [String] = []
    for category in orderedCategories {
        let categoryString = String(category.split(separator: "_")[1])
        categories.append(categoryString)
    }

    return categories
}
