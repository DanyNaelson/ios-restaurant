//
//  SignInWithFacebook.swift
//  laostra
//
//  Created by Daniel Mejia on 27/10/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI
import FBSDKLoginKit

struct SignInWithFacebook : UIViewRepresentable {
    
    var signInFacebook: (_ accessToken: String) -> Void
    
    func makeCoordinator() -> FacebookSignInCoordinator {
        return FacebookSignInCoordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<SignInWithFacebook>) -> FBLoginButton {
        let button = FBLoginButton()
        button.permissions = ["email", "public_profile"]
        button.delegate = context.coordinator

        return button
    }
    
    func updateUIView(_ uiView: FBLoginButton, context: UIViewRepresentableContext<SignInWithFacebook>) { }
}
