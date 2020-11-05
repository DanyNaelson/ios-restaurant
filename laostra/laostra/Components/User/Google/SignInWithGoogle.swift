//
//  SignInWithGoogle.swift
//  laostra
//
//  Created by Daniel Mejia on 20/08/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI
import GoogleSignIn

struct SignInWithGoogle : UIViewRepresentable {
    
    var signInGoogle: (_ idToken: String) -> Void
    
    func makeCoordinator() -> GoogleSignInCoordinator {
        return GoogleSignInCoordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<SignInWithGoogle>) -> GIDSignInButton {
        let button = GIDSignInButton()
        button.style = .wide
        
        GIDSignIn.sharedInstance().delegate = context.coordinator
        if(GIDSignIn.sharedInstance()?.presentingViewController == nil){
            GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
        }
        
        return button
    }
    func updateUIView(_ uiView: GIDSignInButton, context: UIViewRepresentableContext<SignInWithGoogle>) {}
}
