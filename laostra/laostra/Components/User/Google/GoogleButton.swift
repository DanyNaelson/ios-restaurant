//
//  GoogleButton.swift
//  laostra
//
//  Created by Daniel Mejia on 26/10/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI
import SwiftyJSON
import ToastUI

struct GoogleButton: View {
    @State private var loaderGoogle = false
    @State private var errorField = ""
    @State private var errorMessage = ""
    @State var showingPopup : Bool = false
    @Binding var viewNumber : Int
    @Binding var selection : Int
    @Binding var showModal : Bool
    @EnvironmentObject var appState : AppState
    @ObservedObject var userManager : UserManager
    
    func signInGoogle(idToken: String) -> Void {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        self.loaderGoogle = true
        self.errorField = ""
        self.errorMessage = ""

        self.userManager.signInGoogle(idToken: idToken){ response in

            self.loaderGoogle = false
            let data = JSON(response)

            if data["ok"] == true {
                self.appState.isUserLogged = true
                UserDefaults.standard.set("\(data["token"])", forKey: "ostraToken")
                UserDefaults.standard.set("\(data["refreshToken"])", forKey: "ostraRefreshToken")
                UserDefaults.standard.set("\(data["user"]["_id"])", forKey: "ostraUserID")

                if data["signUp"] == true {
                    self.viewNumber = 5
                } else {
                    self.showModal = false
                }
            } else if data["ok"] == false {
                self.errorField = data["err"]["field"].string ?? ""
                self.errorMessage = data["err"]["message"].string ?? ""
            }
        }
    }
    
    var body: some View {
        if self.loaderGoogle {
            HStack {
                Spacer()
                ElementLoader(circleSize: 20, colorInitial: Color("primary"), colorEnding: Color("textUnselected"))
                    .padding(15)
                Spacer()
            }
            .background(Color.white)
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: 50)
            .cornerRadius(5)
        } else {
            VStack(alignment: .center, spacing: 20) {
                SignInWithGoogle(signInGoogle: self.signInGoogle)
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

struct GoogleButton_Previews: PreviewProvider {
    static var previews: some View {
        GoogleButton(viewNumber: .constant(1), selection: .constant(4), showModal: .constant(true), userManager: UserManager())
    }
}
