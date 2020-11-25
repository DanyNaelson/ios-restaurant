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
    @Published var drink: Drink = Drink(id: "", status: "", picture: "", name: "", nickname: "", category: CategoryDrink(name: "", nickname: "", order: 1), price: 0, description: "", specifications: "")
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
    
    func getDrink(id: String, completion: @escaping (Drink) -> Void) {
        DispatchQueue.main.async {
            AF.request("\(Environment.menuServiceURL)drink/\(id)").responseJSON{ (response) in

                switch response.result {
                    case .success(let value):
                        let json = JSON(value)

                        if (json["ok"] == true) {
                            self.drink = createDrink(drink: json["drink"])
                            completion(self.drink)
                        }

                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
}
