//
//  StringHelper.swift
//  laostra
//
//  Created by Daniel Mejia on 07/08/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import Foundation

func toCategoryFormat (category: String) -> String {
    let categoryNoAccents = category.folding(options: .diacriticInsensitive, locale: .current)
    let category = categoryNoAccents.replacingOccurrences(of: " ", with: "_").lowercased()

    return category
}
