//
//  FacebookButton.swift
//  laostra
//
//  Created by Daniel Mejia on 20/08/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI
import SwiftyJSON
import Firebase
import ToastUI

struct FacebookButton: View {
    @State private var loaderFacebook = false
    @State private var errorField = ""
    @State private var errorMessage = ""
    @State var showingPopup : Bool = false
    @Binding var viewNumber : Int
    @Binding var selection : Int
    @Binding var showModal : Bool
    @EnvironmentObject var appState : AppState
    @ObservedObject var userManager : UserManager
    
    func signInFacebook(accessToken: String) -> Void {
        hideKeyboard()
        self.loaderFacebook = true
        self.errorField = ""
        self.errorMessage = ""

        self.userManager.signInFacebook(accessToken: accessToken){ response in
            self.loaderFacebook = false
            let data = JSON(response)

            if data["ok"] == true {
                self.appState.isUserLogged = true
                UserDefaults.standard.set("\(data["token"])", forKey: "ostraToken")
                UserDefaults.standard.set("\(data["refreshToken"])", forKey: "ostraRefreshToken")
                UserDefaults.standard.set("\(data["user"]["_id"])", forKey: "ostraUserID")

                if data["signUp"] == true {
                    self.viewNumber = 5
                } else {
                    self.selection = 1
                    self.showModal = false
                }
            } else if data["ok"] == false {
                self.errorField = data["err"]["field"].string ?? ""
                self.errorMessage = data["err"]["message"].string ?? ""
                try! Auth.auth().signOut()
            }
        }
    }
    
    var body: some View {
        if self.loaderFacebook {
            HStack {
                Spacer()
                ElementLoader(circleSize: 20, colorInitial: Color.white, colorEnding: Color.white)
                    .padding(15)
                Spacer()
            }
            .background(Color(red: 0.231, green: 0.349, blue: 0.596, opacity: 1))
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: 50)
            .cornerRadius(5)
        } else {
            VStack(alignment: .center, spacing: 20) {
                SignInWithFacebook(signInFacebook: self.signInFacebook)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 50)
                    .onTapGesture {
                        self.showingPopup.toggle()
                    }
                    .toast(isPresented: self.$showingPopup, dismissAfter: 2.0) {} content: {
                        ToastView(LocalizedStringKey("hold_button_2_seconds"))
                            .toastViewStyle(InfoToastViewStyle())
                    }
                if self.errorMessage != "" {
                    ErrorField(errorMessage: self.errorMessage)
                }
            }
        }
    }
}

struct FacebookButton_Previews: PreviewProvider {
    static var previews: some View {
        FacebookButton(viewNumber: .constant(1), selection: .constant(4), showModal: .constant(true), userManager: UserManager())
    }
}
