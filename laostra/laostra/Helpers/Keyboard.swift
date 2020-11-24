//
//  Keyboard.swift
//  laostra
//
//  Created by Daniel Mejia on 23/11/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI

func hideKeyboard(){
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}
