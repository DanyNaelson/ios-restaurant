//
//  OrderManager.swift
//  laostra
//
//  Created by Daniel Mejia on 26/11/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Combine

class OrderManager: ObservableObject {
    @Published var order: Order = Order(id: "", orderNum: "", status: "ORDERED", total: 0, ownerId: "", orderItems: [])
    @Published var orders = [Order]()
    
    func getOrdersByUser(completion: @escaping (Any) -> Void) {
        let token = UserDefaults.standard.string(forKey: "ostraToken")!
        let refreshToken = UserDefaults.standard.string(forKey: "ostraRefreshToken")!
        let userID = UserDefaults.standard.string(forKey: "ostraUserID")!
        let headers: HTTPHeaders = [
            "Authorization": token
        ]
        self.orders = []
        
        DispatchQueue.main.async {
            AF.request("\(Environment.menuServiceURL)orders/user/\(userID)", headers: headers, interceptor: NetworkInterceptor(token: token, refreshToken: refreshToken)).validate(statusCode: 200 ..< 401).responseJSON{ (response) in
                switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        
                        if (json["ok"] == true){
                            for order in json["orders"] {
                                let orderObject = createOrder(order: order.1)

                                self.orders.append(orderObject)
                            }
                            completion(value)
                        } else {
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
                            default:
                                let error: NSDictionary = ["ok": false, "err": ["error": error, "message": "server_error"]]
                                completion(error)
                        }
                }
            }
        }
    }
    
    func makeOrder(userID: String, orderItems: [Decodable], completion: @escaping (Any) -> Void) {
        let token = UserDefaults.standard.string(forKey: "ostraToken")!
        let refreshToken = UserDefaults.standard.string(forKey: "ostraRefreshToken")!
        let headers: HTTPHeaders = [
            "Authorization": token
        ]
        let parameters : [String : Any] = [
            "ownerId": userID,
            "orderItems": arrayModelToParameters(modelArray: orderItems)
        ]

        guard let url = URL(string: "\(Environment.menuServiceURL)order") else { return }

        DispatchQueue.main.async {
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers, interceptor: NetworkInterceptor(token: token, refreshToken: refreshToken)).validate(statusCode: 200 ..< 401).responseJSON { (response) in

                switch response.result {
                    case .success(let value):
                        let json = JSON(value)

                        if (json["ok"] == true) {
                            self.order = createOrder(order: json["order"])
                            completion(value)
                        } else {
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
                            default:
                                let error: NSDictionary = ["ok": false, "err": ["error": error, "message": "server_error"]]
                                completion(error)
                        }
                }
            }
        }
    }
}
