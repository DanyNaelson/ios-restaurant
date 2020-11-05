//
//  AppleSignInCoordinator.swift
//  laostra
//
//  Created by Daniel Mejia on 21/10/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI
import AuthenticationServices

class AppleSignInCoordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    var parent: SignInWithApple?
    
    init(_ parent: SignInWithApple) {
      self.parent = parent
      super.init()
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let vc = UIApplication.shared.windows.last?.rootViewController
        return (vc?.view.window!)!
    }

    func authorizationController(controller: ASAuthorizationController,didCompleteWithAuthorization authorization: ASAuthorization){
        guard let credentials = authorization.credential as?ASAuthorizationAppleIDCredential else {
            print("credentials not found.")
            return
        }

        let identityTokenString = String(decoding: credentials.identityToken!, as: UTF8.self)
        let user = credentials.user
        
        UserDefaults.standard.set(user, forKey: "appleID")

        parent?.signInApple(user, identityTokenString)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error){
        print("error", error)
    }
    
    @objc func didTapButton() {
        //Create an object of the ASAuthorizationAppleIDProvider
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        //Create a request
        let request = appleIDProvider.createRequest()
        //Define the scope of the request
        request.requestedScopes = [.fullName, .email]
        //Make the request
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.presentationContextProvider = self
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
}
