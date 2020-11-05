//
//  NetworkInterceptor.swift
//  laostra
//
//  Created by Daniel Mejia on 24/09/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkInterceptor: RequestInterceptor {
    private var token: String
    private var refreshToken: String

    init(token: String, refreshToken: String) {
        self.token = token
        self.refreshToken = refreshToken
    }

    // MARK: - RequestAdapter
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        urlRequest.headers.add(.authorization(self.token))

        completion(.success(urlRequest))
    }

    // MARK: - RequestRetrier
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            let parameters : Parameters = [
                "refreshToken": self.refreshToken
            ]
            
            guard let url = URL(string: "\(Environment.userServiceURL)refresh-token") else { return }

            DispatchQueue.main.async {
                AF.request(url, method: .post, parameters: parameters).responseJSON { (response) in
                    switch response.result {
                        case .success(let value):
                            let json = JSON(value)

                            if json["err"]["error"] == "not_authorized_final" || json["err"]["error"] == "user_not_found" {
                                completion(.doNotRetry)
                            }

                            self.token = json["token"].string ?? ""
                            self.refreshToken = json["refreshToken"].string ?? ""
                            let userID = json["user"]["_id"].string ?? ""
                            refreshUserDefault(token: self.token, refreshToken: self.refreshToken, userID: userID)

                            completion(.retry)

                        case .failure(let error):
                            print(error)
                            completion(.doNotRetry)
                    }
                }
            }
        } else {
            completion(.doNotRetry)
        }
    }
}
