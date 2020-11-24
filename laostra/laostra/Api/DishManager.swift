//
//  DishManager.swift
//  laostra
//
//  Created by Daniel Mejia on 06/08/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Combine

class DishManager: ObservableObject {
    @Published var dish : Dish = Dish(id: "", status: "", picture: "", name: "", nickname: "", category: CategoryDish(name: "", nickname: "", order: 0), price: 0, description: "")
    @Published var dishes = [Dish]()
    
    func getDishes(query: String) {
        self.dishes = []
        
        DispatchQueue.main.async {
            AF.request("\(Environment.menuServiceURL)dishes\(query)").responseJSON{ (response) in
                switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        for dish in json["dishes"] {
                            let dishObject = createDish(dish: dish.1)

                            self.dishes.append(dishObject)
                        }

                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
    
    func getDish(id: String, completion: @escaping (Dish) -> Void) {
        DispatchQueue.main.async {
            AF.request("\(Environment.menuServiceURL)dish/\(id)").responseJSON{ (response) in

                switch response.result {
                    case .success(let value):
                        let json = JSON(value)

                        if (json["ok"] == true) {
                            self.dish = createDish(dish: json["dish"])
                            completion(self.dish)
                        }

                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
}
