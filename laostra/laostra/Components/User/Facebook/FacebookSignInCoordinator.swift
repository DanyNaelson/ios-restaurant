//
//  FacebookSignInCoordinator.swift
//  laostra
//
//  Created by Daniel Mejia on 27/10/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import Firebase

class FacebookSignInCoordinator: NSObject, LoginButtonDelegate {
    var parent: SignInWithFacebook?
    
    init(_ parent: SignInWithFacebook) {
      self.parent = parent
      super.init()
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
          print("error", error.localizedDescription)
          return
        }

        if(AccessToken.current != nil) {
            self.parent?.signInFacebook(AccessToken.current!.tokenString)
            AccessToken.current = nil
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        try! Auth.auth().signOut()
    }
}
