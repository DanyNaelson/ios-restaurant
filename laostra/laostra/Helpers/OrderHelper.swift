//
//  OrderHelper.swift
//  laostra
//
//  Created by Daniel Mejia on 26/11/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import Foundation
import SwiftyJSON

func createOrder(order: JSON) -> Order{
    let id = order["_id"].string ?? ""
    let orderNum = order["orderNum"].string ?? ""
    let status = order["status"].string ?? ""
    let ownerId = order["ownerId"].string ?? ""
    let orderItems : [OrderItem] = order["orderItems"].isEmpty ? [] : jsonArrayToOrderItems(array: order["orderItems"])
    let orderObject = Order(id: id, orderNum: orderNum, status: status, total: 0, ownerId: ownerId, orderItems: orderItems)
    
    return orderObject
}

func jsonArrayToOrderItems(array: JSON) -> [ OrderItem ] {
    var orderItems: [ OrderItem ] = []

    for orderItem in array {
        let id = orderItem.1["_id"].string ?? ""
        let name = orderItem.1["name"].string ?? ""
        let picture = orderItem.1["photo"].string ?? ""
        let type = orderItem.1["type"].string ?? ""
        let price = orderItem.1["price"].int ?? 0
        let quantity = orderItem.1["quantity"].int ?? 0
        let total = orderItem.1["total"].int ?? 0
        let specifications = orderItem.1["specifications"].string ?? ""
        let newItem = OrderItem(id: id, name: name, picture: picture, type: type, price: price, quantity: quantity, total: total, specifications: specifications)

        orderItems.append(newItem)
    }
    
    return orderItems
}

func createOrderItems(cartItems: [ CartItem ]) -> [ OrderItem ] {
    var orderItems : [ OrderItem ] = []
    
    for cartItem in cartItems {
        let newItem = OrderItem(id: cartItem.id, name: cartItem.name, picture: cartItem.photo, type: cartItem.type.uppercased(), price: Int(cartItem.price), quantity: Int(cartItem.quantity), total: Int(cartItem.total), specifications: cartItem.specifications)

        orderItems.append(newItem)
    }
    
    return orderItems
}
