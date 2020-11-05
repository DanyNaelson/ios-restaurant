//
//  GoogleSignInCoordinator.swift
//  laostra
//
//  Created by Daniel Mejia on 26/10/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI
import GoogleSignIn
import Firebase

class GoogleSignInCoordinator: NSObject, GIDSignInDelegate {
    var parent: SignInWithGoogle?
    
    init(_ parent: SignInWithGoogle) {
      self.parent = parent
      super.init()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }

        guard let authentication = user.authentication else { return }
        
        self.parent?.signInGoogle(authentication.idToken!)
    }
}
