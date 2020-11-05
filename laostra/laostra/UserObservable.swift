//
//  UserObservable.swift
//  laostra
//
//  Created by Daniel Mejia on 20/08/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import Foundation

class UserObservable : ObservableObject {
    @Published var isUserLogged = false
    
    func logged() {
        self.isUserLogged = true
    }
}
