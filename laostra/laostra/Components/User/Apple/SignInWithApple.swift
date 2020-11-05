//
//  SignInWithApple.swift
//  laostra
//
//  Created by Daniel Mejia on 16/10/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI
import AuthenticationServices

struct SignInWithApple: UIViewRepresentable {
    var signInApple: (_ user: String, _ token: String) -> Void
    
    func makeCoordinator() -> AppleSignInCoordinator {
        return AppleSignInCoordinator(self)
    }
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        //Creating the apple sign in button
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn,
        authorizationButtonStyle: .black)

        //Adding the tap action on the apple sign in button
        button.addTarget(context.coordinator, action: #selector(AppleSignInCoordinator.didTapButton), for: .touchUpInside)

        return button
    }
  
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {}
}
