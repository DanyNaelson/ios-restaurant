//
//  CartItem.swift
//  laostra
//
//  Created by Daniel Mejia on 10/11/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import Foundation
import CoreData

class CartItem: NSManagedObject, Identifiable {
    @NSManaged public var id : String
    @NSManaged public var name : String
    @NSManaged public var item_description : String
    @NSManaged public var price : Int16
    @NSManaged public var quantity : Int16
    @NSManaged public var photo : String
    @NSManaged public var total : Int16
    @NSManaged public var owner_id : String
    @NSManaged public var type : String
    @NSManaged public var specifications : String
}

extension CartItem {
    static func getItemByIdAndByOwner(id: String, ownerId: String) -> NSFetchRequest<CartItem> {
        let request : NSFetchRequest<CartItem> = CartItem.fetchRequest() as! NSFetchRequest<CartItem>
        request.predicate = NSPredicate(format: "id == %@", id)
        request.predicate = NSPredicate(format: "owner_id == %@", id)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        return request
    }
    
    static func getItemsByOwner(ownerId: String) -> NSFetchRequest<CartItem> {
        let request : NSFetchRequest<CartItem> = CartItem.fetchRequest() as! NSFetchRequest<CartItem>
        
        if ownerId != "" {
            request.predicate = NSPredicate(format: "owner_id == %@", ownerId)
        } else {
            request.predicate = NSPredicate(format: "owner_id == %@", "none")
        }
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        return request
    }
    
    static func updateCartItemByDish(newCartItem: CartItem, dish: Dish, userID: String) {
        newCartItem.id = dish.id
        newCartItem.name = dish.name
        newCartItem.item_description = dish.description
        newCartItem.owner_id = userID
        newCartItem.photo = dish.picture
        newCartItem.price = Int16(dish.price)
        newCartItem.quantity = Int16(dish.quantity)
        newCartItem.total = Int16(dish.price) * Int16(dish.quantity)
        newCartItem.type = "dish"
    }
    
    static func updateCartItemByDrink(newCartItem: CartItem, drink: Drink, userID: String) {
        newCartItem.id = drink.id
        newCartItem.name = drink.name
        newCartItem.item_description = drink.description
        newCartItem.owner_id = userID
        newCartItem.photo = drink.picture
        newCartItem.price = Int16(drink.price)
        newCartItem.quantity = Int16(drink.quantity)
        newCartItem.total = Int16(drink.price) * Int16(drink.quantity)
        newCartItem.type = "drink"
        newCartItem.specifications = drink.specifications
    }
}
