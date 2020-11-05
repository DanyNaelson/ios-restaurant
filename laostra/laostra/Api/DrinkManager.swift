//
//  DrinkManager.swift
//  laostra
//
//  Created by Daniel Mejia on 05/10/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Combine

class DrinkManager: ObservableObject {
    @Published var drinks = [Drink]()
    
    func getDrinks(query: String) {
        self.drinks = []
        
        DispatchQueue.main.async {
            AF.request("\(Environment.menuServiceURL)drinks\(query)").responseJSON{ (response) in
                switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        for drink in json["drinks"] {
                            let drinkObject = createDrink(drink: drink.1)

                            self.drinks.append(drinkObject)
                        }

                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
}
