//
//  UserHelper.swift
//  laostra
//
//  Created by Daniel Mejia on 23/09/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import Foundation
import SwiftyJSON

func createUser(user: JSON) -> User{
    let birthdayString = user["birthday"].string ?? ""
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
    let formattedBirthday = formatter.date(from: birthdayString)

    let id = user["_id"].string ?? ""
    let email = user["email"].string ?? ""
    let zipCode = user["zipCode"].string ?? ""
    let role = user["role"].string ?? "USER"
    let nickname = user["nickname"].string ?? ""
    let confirm = user["confirm"].bool ?? false
    let birthday = formattedBirthday ?? Date()
    let cellPhone = user["cellPhone"].string ?? ""
    let gender = user["gender"].string ?? "FEMALE"
    let google = user["google"].bool ?? false
    let facebook = user["facebook"].bool ?? false
    let withEmail = user["withEmail"].bool ?? true
    let photo = user["photo"].string ?? ""
    let favoriteDrinks = user["favoriteDrinks"].isEmpty ? [] : jsonArrayToFavoriteDrinks(array: user["favoriteDrinks"])
    let favoriteDishes = user["favoriteDishes"].isEmpty ? [] : jsonArrayToFavoriteDishes(array: user["favoriteDishes"])
    let promotions = user["promotions"].isEmpty ? [] : jsonArrayToPromotions(array: user["promotions"])

    let userObject = User(id: id, email: email, zipCode: zipCode, role: role, nickname: nickname, confirm: confirm, birthday: birthday, cellPhone: cellPhone, gender: gender, google: google, facebook: facebook, withEmail: withEmail, photo: photo, favoriteDrinks: favoriteDrinks, favoriteDishes: favoriteDishes, promotions: promotions)
    
    return userObject
}

func arrayModelToParameters(modelArray: [Decodable]) -> [Dictionary<String, Any>]{
    var finalArray: [Dictionary<String, Any>] = []
    
    for model in modelArray {
        var dictionary: Dictionary<String, Any> = [:]
        let mirror = Mirror(reflecting: model)
        
        for child in mirror.children  {
            dictionary.updateValue(child.value, forKey: "\(child.label ?? "")")
        }

        finalArray.append(dictionary)
    }
    
    return finalArray
}

func jsonArrayToFavoriteDrinks(array: JSON) -> [ FavoriteDrink ] {
    var favoriteDrinks: [ FavoriteDrink ] = []

    for drink in array {
        let id = drink.1["_id"].string ?? ""
        let name = drink.1["name"].string ?? ""
        let picture = drink.1["picture"].string ?? ""
        let category = drink.1["category"].string ?? ""
        let description = drink.1["description"].string ?? ""
        let drink = FavoriteDrink(_id: id, picture: picture, name: name, category: category, description: description)
        
        favoriteDrinks.append(drink)
    }
    
    return favoriteDrinks
}

func jsonArrayToFavoriteDishes(array: JSON) -> [ FavoriteDish ] {
    var favoriteDishes: [ FavoriteDish ] = []

    for dish in array {
        let id = dish.1["_id"].string ?? ""
        let name = dish.1["name"].string ?? ""
        let picture = dish.1["picture"].string ?? ""
        let category = dish.1["category"].string ?? ""
        let description = dish.1["description"].string ?? ""
        let dish = FavoriteDish(_id: id, picture: picture, name: name, category: category, description: description)
        
        favoriteDishes.append(dish)
    }
    
    return favoriteDishes
}

func jsonArrayToPromotions(array: JSON) -> [ Promotion ] {
    var promotions: [ Promotion ] = []

    for promotion in array {
        let endDateString = promotion.1["endDate"].string ?? ""
        let startDateString = promotion.1["startDate"].string ?? ""
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
        let formattedEndDate = formatter.date(from: endDateString)
        let formattedStartDate = formatter.date(from: startDateString)
        
        let id = promotion.1["_id"].string ?? ""
        let status = promotion.1["status"].string ?? ""
        let name = promotion.1["name"].string ?? ""
        let code = promotion.1["code"].string ?? ""
        let type = promotion.1["type"].string ?? ""
        let value = promotion.1["value"].int ?? 0
        let description = promotion.1["description"].string ?? ""
        let endDate = formattedEndDate ?? Date()
        let startDate = formattedStartDate ?? Date()
        let promotion = Promotion(_id: id, status: status, name: name, code: code, type: type, value: value, description: description, endDate: endDate, startDate: startDate)
        
        promotions.append(promotion)
    }
    
    return promotions
}

func refreshUserDefault(token: String, refreshToken: String, userID: String){
    UserDefaults.standard.set(token, forKey: "ostraToken")
    UserDefaults.standard.set(refreshToken, forKey: "ostraRefreshToken")
    UserDefaults.standard.set(userID, forKey: "ostraUserID")
}

func logout(appState: AppState){
    UserDefaults.standard.set(nil, forKey: "ostraToken")
    UserDefaults.standard.set(nil, forKey: "ostraRefreshToken")
    UserDefaults.standard.set(nil, forKey: "ostraUserID")
    appState.isUserLogged = false
}
