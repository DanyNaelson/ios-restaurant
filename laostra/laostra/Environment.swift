//
//  Environment.swift
//  laostra
//
//  Created by Daniel Mejia on 20/10/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import Foundation

public enum Environment {
    // MARK: - Plist
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()

    // MARK: - Plist values
    static let userServiceURL: URL = {
        guard let userServiceURLString = Environment.infoDictionary["UserServiceUrl"] as? String else {
            fatalError("User service url not set in plist for this environment")
        }
        guard let url = URL(string: userServiceURLString) else {
            fatalError("User service url is invalid")
        }
        return url
    }()

    static let menuServiceURL: URL = {
        guard let menuServiceURLString = Environment.infoDictionary["MenuServiceUrl"] as? String else {
            fatalError("Menu service url not set in plist for this environment")
        }
        guard let url = URL(string: menuServiceURLString) else {
            fatalError("Menu service url is invalid")
        }
        return url
    }()

    static let emailServiceURL: URL = {
        guard let emailServiceURLString = Environment.infoDictionary["EmailServiceUrl"] as? String else {
            fatalError("Email service url not set in plist for this environment")
        }
        guard let url = URL(string: emailServiceURLString) else {
            fatalError("Email service url is invalid")
        }
        return url
    }()
}
