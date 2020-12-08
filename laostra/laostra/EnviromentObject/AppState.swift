//
//  AppState.swift
//  laostra
//
//  Created by Daniel Mejia on 10/09/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import SwiftyJSON

class AppState: ObservableObject {
    
    @Published var fullScreenShow: Bool = false
    @Published var elementShow: Bool = false
    @Published var isUserLogged: Bool = false
    @Published var userNickname: String = ""
    @Published var userRole: String = "USER"
    @Published var tabNumber: Int = 1
    @Published var showModal: Bool = false
    @Published var userManager: UserManager = UserManager()
    @Published var dishManager: DishManager = DishManager()
    @Published var drinkManager: DrinkManager = DrinkManager()
    @Published var orderManager: OrderManager = OrderManager()
    
}
