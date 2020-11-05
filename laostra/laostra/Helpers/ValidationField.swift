//
//  ValidationField.swift
//  laostra
//
//  Created by Daniel Mejia on 02/11/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import Foundation

class ValidationField {
    var errorField : String = ""
    var errorMessage : String = ""
    var isValid : Bool = true
    
    func validateZipCode(value: String) -> ValidationField {
        if value == "" {
            self.errorField = "zipCode"
            self.errorMessage = "required"
            self.isValid = false
        } else if value.count != 5 {
            self.errorField = "zipCode"
            self.errorMessage = "must_contain_5_digits"
            self.isValid = false
        } else {
            self.errorField = ""
            self.errorMessage = ""
            self.isValid = true
        }
        
        return self
    }
    
    func validateEmail(email: String) -> ValidationField {
        let emailPred = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
        
        if email == "" {
            self.errorField = "email"
            self.errorMessage = "required"
            self.isValid = false
        } else if !emailPred.evaluate(with: email) {
            self.errorField = "email"
            self.errorMessage = "invalid_email"
            self.isValid = false
        } else {
            self.errorField = ""
            self.errorMessage = ""
            self.isValid = true
        }
        
        return self
    }
    
    func validatePassword(password: String) -> ValidationField {
        let passwordRegEx = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*_])[a-zA-Z0-9!@#$%^&*_]{8,16}$"
        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        
        if password == "" {
            self.errorField = "password"
            self.errorMessage = "required"
            self.isValid = false
        } else if !passwordPred.evaluate(with: password) {
            self.errorField = "password"
            self.errorMessage = "invalid_password"
            self.isValid = false
        } else {
            self.errorField = ""
            self.errorMessage = ""
            self.isValid = true
        }
        
        return self
    }
}
