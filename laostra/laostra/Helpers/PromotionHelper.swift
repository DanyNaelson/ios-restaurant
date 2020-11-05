//
//  PromotionHelper.swift
//  laostra
//
//  Created by Daniel Mejia on 29/10/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import Foundation
import SwiftyJSON

func createPromotion(promotion: JSON) -> Promotion{
    let endDateString = promotion["endDate"].string ?? ""
    let startDateString = promotion["startDate"].string ?? ""
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
    let formattedEndDate = formatter.date(from: endDateString)
    let formattedStartDate = formatter.date(from: startDateString)
    
    let id = promotion["_id"].string ?? ""
    let status = promotion["status"].string ?? ""
    let name = promotion["name"].string ?? ""
    let code = promotion["code"].string ?? ""
    let type = promotion["type"].string ?? ""
    let value = promotion["value"].int ?? 0
    let description = promotion["description"].string ?? ""
    let endDate = formattedEndDate ?? Date()
    let startDate = formattedStartDate ?? Date()
    let promotionObject = Promotion(_id: id, status: status, name: name, code: code, type: type, value: value, description: description, endDate: endDate, startDate: startDate)
    
    return promotionObject
}
