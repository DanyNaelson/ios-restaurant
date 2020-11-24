//
//  UserManager.swift
//  laostra
//
//  Created by Daniel Mejia on 21/08/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Combine

class UserManager: ObservableObject {
    @Published var user : User = User(id: "", email: "", zipCode: "", role: "USER", nickname: "", confirm: false, birthday: Date(), cellPhone: "", gender: "MALE", google: false, facebook: false, withEmail: false, photo: "", favoriteDrinks: [], favoriteDishes: [], promotions: [])
    @Published var users = [User]()
    
    func signUp(email: String, password: String, completion: @escaping (Any) -> Void) {
        let parameters : Parameters = [
            "email": email,
            "password": password
        ]

        guard let url = URL(string: "\(Environment.userServiceURL)sign-up") else { return }
        
        DispatchQueue.main.async {
            AF.request(url, method: .post, parameters: parameters).responseJSON { (response) in
                switch response.result {
                    case .success(let value):
                        let json = JSON(value)

                        if (json["ok"] == true) {
                            self.user = createUser(user: json["user"])
                        }
                        
                        completion(value)

                    case .failure(let error):
                        let error: NSDictionary = ["ok": false, "err": ["error": error, "message": "server_error"]]
                        completion(error)
                }
            }
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Any) -> Void) {
        
        let parameters : Parameters = [
            "email": email,
            "password": password
        ]

        guard let url = URL(string: "\(Environment.userServiceURL)login") else { return }
        
        DispatchQueue.main.async {
            AF.request(url, method: .post, parameters: parameters).responseJSON { (response) in
                switch response.result {
                    case .success(let value):
                        let json = JSON(value)

                        if (json["ok"] == true) {
                            self.user = createUser(user: json["user"])
                        }
                        
                        completion(value)

                    case .failure(let error):
                        let error: NSDictionary = ["ok": false, "err": ["error": error, "message": "server_error"]]
                        completion(error)
                }
            }
        }
    }
    
    func signInApple(user: String, identityToken: String, completion: @escaping (Any) -> Void) {
        let parameters : Parameters = [
            "user": user,
            "identityToken": identityToken
        ]

        guard let url = URL(string: "\(Environment.userServiceURL)sign-in/apple") else { return }
        
        DispatchQueue.main.async {
            AF.request(url, method: .post, parameters: parameters).responseJSON { (response) in
                switch response.result {
                    case .success(let value):
                        let json = JSON(value)

                        if (json["ok"] == true) {
                            self.user = createUser(user: json["user"])
                        }
                        
                        completion(value)

                    case .failure(let error):
                        let error: NSDictionary = ["ok": false, "err": ["error": error, "message": "server_error"]]
                        completion(error)
                }
            }
        }
    }
    
    func signInGoogle(idToken: String, completion: @escaping (Any) -> Void) {
        let parameters : Parameters = [
            "idToken": idToken
        ]

        guard let url = URL(string: "\(Environment.userServiceURL)sign-in/google") else { return }

        DispatchQueue.main.async {
            AF.request(url, method: .post, parameters: parameters).responseJSON { (response) in
                switch response.result {
                    case .success(let value):
                        let json = JSON(value)

                        if (json["ok"] == true) {
                            self.user = createUser(user: json["user"])
                        }

                        completion(value)

                    case .failure(let error):
                        let error: NSDictionary = ["ok": false, "err": ["error": error, "message": "server_error"]]
                        completion(error)
                }
            }
        }
    }
    
    func signInFacebook(accessToken: String, completion: @escaping (Any) -> Void) {
        let parameters : Parameters = [
            "accessToken": accessToken
        ]

        guard let url = URL(string: "\(Environment.userServiceURL)sign-in/facebook") else { return }

        DispatchQueue.main.async {
            AF.request(url, method: .post, parameters: parameters).responseJSON { (response) in
                switch response.result {
                    case .success(let value):
                        let json = JSON(value)

                        if (json["ok"] == true) {
                            self.user = createUser(user: json["user"])
                        }

                        completion(value)

                    case .failure(let error):
                        let error: NSDictionary = ["ok": false, "err": ["error": error, "message": "server_error"]]
                        completion(error)
                }
            }
        }
    }
    
    func getProfile(userID: String, completion: @escaping (Any) -> Void) {
        let token = UserDefaults.standard.string(forKey: "ostraToken")!
        let refreshToken = UserDefaults.standard.string(forKey: "ostraRefreshToken")!
        let headers: HTTPHeaders = [
            "Authorization": token
        ]

        guard let url = URL(string: "\(Environment.userServiceURL)user/\(userID)") else { return }

        DispatchQueue.main.async {
            AF.request(url, method: .get, headers: headers, interceptor: NetworkInterceptor(token: token, refreshToken: refreshToken)).validate(statusCode: 200 ..< 401).responseJSON { (response) in
                switch response.result {
                    case .success(let value):
                        let json = JSON(value)

                        if (json["ok"] == true) {
                            self.user = createUser(user: json["user"])
                            completion(value)
                        } else {
                            if json["err"]["message"] == "user_not_found" {
                                let error: NSDictionary = ["ok": false, "err": ["error": "user_not_found", "message": "logout"]]
                                completion(error)
                            }
                            
                            if json["err"]["message"] == "not_authorized" {
                                let error: NSDictionary = ["ok": false, "err": ["error": "not_autorized", "message": "logout"]]
                                completion(error)
                            }
                        }

                    case .failure(let error):
                        switch response.response?.statusCode {
                            case 401:
                                let error: NSDictionary = ["ok": false, "err": ["error": "not_authorized_final", "message": "logout"]]
                                completion(error)
                            case 404:
                                let error: NSDictionary = ["ok": false, "err": ["error": "user_not_found", "message": "logout"]]
                                completion(error)
                            default:
                                let error: NSDictionary = ["ok": false, "err": ["error": error, "message": "server_error"]]
                                completion(error)
                        }
                }
            }
        }
    }
    
    func refreshToken(refreshToken: String, completion: @escaping (Any) -> Void) {
        let parameters : Parameters = [
            "refreshToken": refreshToken
        ]
        
        guard let url = URL(string: "\(Environment.userServiceURL)refresh-token") else { return }
        
        DispatchQueue.main.async {
            AF.request(url, method: .post, parameters: parameters).responseJSON { (response) in
                switch response.result {
                    case .success(let value):
                        let json = JSON(value)

                        if json["err"]["message"] == "not_authorized_final" || json["err"]["message"] == "user_not_found" {
                            let error: NSDictionary = ["ok": false, "err": ["error": "not_autorized_final", "message": "logout"]]
                            completion(error)
                        }

                        completion(value)

                    case .failure(let error):
                        let error: NSDictionary = ["ok": false, "err": ["error": error, "message": "logout"]]
                        completion(error)
                }
            }
        }
    }
    
    func sendConfirmationCode(userID: String, confirmationCode: String, completion: @escaping (Any) -> Void) {
        let token = UserDefaults.standard.string(forKey: "ostraToken")!
        let refreshToken = UserDefaults.standard.string(forKey: "ostraRefreshToken")!
        let headers: HTTPHeaders = [
            "Authorization": token
        ]
        let parameters : Parameters = [
            "confirmationCode": confirmationCode
        ]

        guard let url = URL(string: "\(Environment.userServiceURL)verify-confirmation-code/\(userID)") else { return }

        DispatchQueue.main.async {
            AF.request(url, method: .put, parameters: parameters, headers: headers, interceptor: NetworkInterceptor(token: token, refreshToken: refreshToken)).validate(statusCode: 200 ..< 401).responseJSON { (response) in

                switch response.result {
                    case .success(let value):
                        let json = JSON(value)

                        if (json["ok"] == true) {
                            self.user = createUser(user: json["user"])
                            completion(value)
                        } else {
                            if json["err"]["message"] == "user_not_found" {
                                let error: NSDictionary = ["ok": false, "err": ["error": "user_not_found", "message": "logout"]]
                                completion(error)
                            }
                            
                            if json["err"]["message"] == "not_authorized" {
                                let error: NSDictionary = ["ok": false, "err": ["error": "not_autorized", "message": "logout"]]
                                completion(error)
                            }
                        }
                        
                        completion(value)

                    case .failure(let error):
                        switch response.response?.statusCode {
                            case 401:
                                let error: NSDictionary = ["ok": false, "err": ["error": "not_authorized_final", "message": "logout"]]
                                completion(error)
                            case 404:
                                let error: NSDictionary = ["ok": false, "err": ["error": "user_not_found", "message": "logout"]]
                                completion(error)
                            default:
                                let error: NSDictionary = ["ok": false, "err": ["error": error, "message": "server_error"]]
                                completion(error)
                        }
                }
            }
        }
    }
    
    func resendConfirmationCode(userID: String, email: String, completion: @escaping (Any) -> Void) {
        let token = UserDefaults.standard.string(forKey: "ostraToken")!
        let refreshToken = UserDefaults.standard.string(forKey: "ostraRefreshToken")!
        let headers: HTTPHeaders = [
            "Authorization": token
        ]
        let parameters : Parameters = [
            "email": email
        ]

        guard let url = URL(string: "\(Environment.userServiceURL)v1/resend-code/\(userID)") else { return }

        DispatchQueue.main.async {
            AF.request(url, method: .put, parameters: parameters, headers: headers, interceptor: NetworkInterceptor(token: token, refreshToken: refreshToken)).validate(statusCode: 200 ..< 401).responseJSON { (response) in

                switch response.result {
                    case .success(let value):
                        let json = JSON(value)

                        if (json["ok"] == true) {
                            self.user = createUser(user: json["user"])
                            completion(value)
                        } else {
                            if json["err"]["message"] == "user_not_found" {
                                let error: NSDictionary = ["ok": false, "err": ["error": "user_not_found", "message": "logout"]]
                                completion(error)
                            }
                            
                            if json["err"]["message"] == "not_authorized" {
                                let error: NSDictionary = ["ok": false, "err": ["error": "not_autorized", "message": "logout"]]
                                completion(error)
                            }
                        }
                        
                        completion(value)

                    case .failure(let error):
                        switch response.response?.statusCode {
                            case 401:
                                let error: NSDictionary = ["ok": false, "err": ["error": "not_authorized_final", "message": "logout"]]
                                completion(error)
                            case 404:
                                let error: NSDictionary = ["ok": false, "err": ["error": "user_not_found", "message": "logout"]]
                                completion(error)
                            default:
                                let error: NSDictionary = ["ok": false, "err": ["error": error, "message": "server_error"]]
                                completion(error)
                        }
                }
            }
        }
    }
    
    func updateProfile(userID: String, body: [String: Any], completion: @escaping (Any) -> Void) {
        let token = UserDefaults.standard.string(forKey: "ostraToken")!
        let refreshToken = UserDefaults.standard.string(forKey: "ostraRefreshToken")!
        let headers: HTTPHeaders = [
            "Authorization": token
        ]
        let parameters : Parameters = body

        guard let url = URL(string: "\(Environment.userServiceURL)user/\(userID)") else { return }

        DispatchQueue.main.async {
            AF.request(url, method: .put, parameters: parameters, headers: headers, interceptor: NetworkInterceptor(token: token, refreshToken: refreshToken)).validate(statusCode: 200 ..< 401).responseJSON { (response) in

                switch response.result {
                    case .success(let value):
                        let json = JSON(value)

                        if (json["ok"] == true) {
                            self.user = createUser(user: json["user"])
                            completion(value)
                        } else {
                            if json["err"]["message"] == "user_not_found" {
                                let error: NSDictionary = ["ok": false, "err": ["error": "user_not_found", "message": "logout"]]
                                completion(error)
                            }
                            
                            if json["err"]["message"] == "not_authorized" {
                                let error: NSDictionary = ["ok": false, "err": ["error": "not_autorized", "message": "logout"]]
                                completion(error)
                            }
                        }
                        
                        completion(value)

                    case .failure(let error):
                        switch response.response?.statusCode {
                            case 401:
                                let error: NSDictionary = ["ok": false, "err": ["error": "not_authorized_final", "message": "logout"]]
                                completion(error)
                            case 404:
                                let error: NSDictionary = ["ok": false, "err": ["error": "user_not_found", "message": "logout"]]
                                completion(error)
                            default:
                                let error: NSDictionary = ["ok": false, "err": ["error": error, "message": "server_error"]]
                                completion(error)
                        }
                }
            }
        }
    }
    
    func updateUserPreferences(userID: String, preferences: String, body: [Decodable], completion: @escaping (Any) -> Void) {
        let token = UserDefaults.standard.string(forKey: "ostraToken")!
        let refreshToken = UserDefaults.standard.string(forKey: "ostraRefreshToken")!
        let headers: HTTPHeaders = [
            "Authorization": token
        ]
        let parameters = preferences == "drinks" ? [
            "favoriteDrinks": arrayModelToParameters(modelArray: body)
        ] : [
            "favoriteDishes": arrayModelToParameters(modelArray: body)
        ]

        guard let url = URL(string: "\(Environment.userServiceURL)user/\(preferences)/\(userID)") else { return }

        DispatchQueue.main.async {
            AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: NetworkInterceptor(token: token, refreshToken: refreshToken)).validate(statusCode: 200 ..< 401).responseJSON { (response) in

                switch response.result {
                    case .success(let value):
                        let json = JSON(value)

                        if (json["ok"] == true) {
                            self.user = createUser(user: json["user"])
                            completion(value)
                        } else {
                            if json["err"]["message"] == "user_not_found" {
                                let error: NSDictionary = ["ok": false, "err": ["error": "user_not_found", "message": "logout"]]
                                completion(error)
                            }

                            if json["err"]["message"] == "not_authorized" {
                                let error: NSDictionary = ["ok": false, "err": ["error": "not_autorized", "message": "logout"]]
                                completion(error)
                            }
                        }

                        completion(value)

                    case .failure(let error):
                        switch response.response?.statusCode {
                            case 401:
                                let error: NSDictionary = ["ok": false, "err": ["error": "not_authorized_final", "message": "logout"]]
                                completion(error)
                            case 404:
                                let error: NSDictionary = ["ok": false, "err": ["error": "user_not_found", "message": "logout"]]
                                completion(error)
                            default:
                                let error: NSDictionary = ["ok": false, "err": ["error": error, "message": "server_error"]]
                                completion(error)
                        }
                }
            }
        }
    }
    
    func addPromotion(userID: String, promotion: NSDictionary, completion: @escaping (Any) -> Void) {
        let token = UserDefaults.standard.string(forKey: "ostraToken")!
        let refreshToken = UserDefaults.standard.string(forKey: "ostraRefreshToken")!
        let headers: HTTPHeaders = [
            "Authorization": token
        ]
        let parameters : Parameters = [
            "promotion": promotion
        ]

        guard let url = URL(string: "\(Environment.userServiceURL)user/promotions/add/\(userID)") else { return }

        DispatchQueue.main.async {
            AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: NetworkInterceptor(token: token, refreshToken: refreshToken)).validate(statusCode: 200 ..< 401).responseJSON { (response) in

                switch response.result {
                    case .success(let value):
                        let json = JSON(value)

                        if (json["ok"] == true) {
                            self.user = createUser(user: json["user"])
                            completion(value)
                        } else {
                            if json["err"]["message"] == "user_not_found" {
                                let error: NSDictionary = ["ok": false, "err": ["error": "user_not_found", "message": "logout"]]
                                completion(error)
                            }

                            if json["err"]["message"] == "not_authorized" {
                                let error: NSDictionary = ["ok": false, "err": ["error": "not_autorized", "message": "logout"]]
                                completion(error)
                            }
                        }

                        completion(value)

                    case .failure(let error):
                        switch response.response?.statusCode {
                            case 401:
                                let error: NSDictionary = ["ok": false, "err": ["error": "not_authorized_final", "message": "logout"]]
                                completion(error)
                            case 404:
                                let error: NSDictionary = ["ok": false, "err": ["error": "user_not_found", "message": "logout"]]
                                completion(error)
                            default:
                                let error: NSDictionary = ["ok": false, "err": ["error": error, "message": "server_error"]]
                                completion(error)
                        }
                }
            }
        }
    }
}
