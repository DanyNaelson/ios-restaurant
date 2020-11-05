//
//  Promotion.swift
//  laostra
//
//  Created by Daniel Mejia on 29/10/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import Foundation

struct Promotion : Decodable {
    var _id : String
    var status : String
    var name : String
    var code : String
    var type : String
    var value : Int
    var description : String
    var endDate : Date
    var startDate : Date
}
