//
//  Login.swift
//  laostra
//
//  Created by Daniel Mejia on 04/08/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI
import SwiftyJSON

struct Login: View {
    @State var email : String
    @State var password : String
    @State var errorField : String = ""
    @State var errorMessage : String = ""
    @State var correctResponse : Bool = false
    @State var responseMessage : String = ""
    @State var serverError : String = ""
    @Binding var showModal : Bool
    @EnvironmentObject var appState : AppState
    @SwiftUI.Environment(\.managedObjectContext) var context
    var validationField : ValidationField = ValidationField()
    
    func setErrors(validation: ValidationField) -> Void {
        self.errorField = validation.errorField
        self.errorMessage = validation.errorMessage
    }
    
    func loginView() {
        hideKeyboard()
        // MARK: - Validate email
        self.setErrors(validation: self.validationField.validateEmail(email: self.email))
        guard self.validationField.validateEmail(email: self.email).isValid else { return }
        // MARK: - Validate password
        self.setErrors(validation: self.validationField.validatePassword(password: self.password))
        guard self.validationField.validatePassword(password: self.password).isValid else { return }
        
        self.appState.elementShow = true
        self.errorField = ""
        self.errorMessage = ""
        self.appState.userManager.login(email: self.email, password: self.password){ response in
            self.appState.elementShow = false
            let data = JSON(response)

            if data["ok"] == true {
                self.correctResponse = true
                self.responseMessage = "ready_to_order"
                self.appState.isUserLogged = true
                UserDefaults.standard.set("\(data["token"])", forKey: "ostraToken")
                UserDefaults.standard.set("\(data["refreshToken"])", forKey: "ostraRefreshToken")
                UserDefaults.standard.set("\(data["user"]["_id"])", forKey: "ostraUserID")
                do {
                    let cartItems = try self.context.fetch(CartItem.getItemsByOwner(ownerId: ""))

                    if !cartItems.isEmpty {
                        let userID = UserDefaults.standard.string(forKey: "ostraUserID")!
                        let myCartItems = try self.context.fetch(CartItem.getItemsByOwner(ownerId: userID))

                        for cartItem in cartItems {
                            if let cartItemFound = myCartItems.first(where: {$0.id == cartItem.id}) {
                                cartItemFound.quantity += cartItem.quantity
                                self.context.delete(cartItem)
                            } else {
                                cartItem.owner_id = userID
                            }
                        }

                        do{
                            try self.context.save()
                        } catch let error as NSError {
                            self.errorMessage = error.localizedDescription
                        }
                    }
                } catch let error {
                    fatalError("Failed to fetch entity: \(error)")
                }

                Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
                    self.appState.tabNumber = 1
                    self.showModal = false
                }
            } else if data["ok"] == false {
                self.errorField = data["err"]["field"].string ?? ""
                self.errorMessage = data["err"]["message"].string ?? ""
            }
        }
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .center, spacing: 20) {
                Text(LocalizedStringKey("login"))
                    .foregroundColor(Color("primary"))
                    .font(.title)
                    .fontWeight(.bold)
                    .lineLimit(nil)
                TextField(LocalizedStringKey("email"), text: $email, onEditingChanged: { (changed) in
                    if !changed {
                        self.setErrors(validation: self.validationField.validateEmail(email: self.email))
                    }
                })
                    .padding(20)
                    .background(self.errorField == "email" ? Color.red.opacity(0.25) : Color(red: 0.94, green: 0.94, blue: 0.96, opacity: 0.5))
                    .transition(.fade)
                    .animation(.default)
                    .cornerRadius(5)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                if self.errorField == "email" {
                    ErrorField(errorMessage: self.errorMessage)
                }
                SecureField(LocalizedStringKey("password"), text: $password)
                    .padding(20)
                    .background(self.errorField == "password" ? Color.red.opacity(0.25) : Color(red: 0.94, green: 0.94, blue: 0.96, opacity: 0.5))
                    .cornerRadius(5)
                if self.errorField == "password" {
                    ErrorField(errorMessage: self.errorMessage)
                }
                HStack {
                    Button(action: {
                        self.loginView()
                    }){
                        HStack {
                            Spacer()
                            if self.appState.elementShow {
                                ElementLoader(circleSize: 20, colorInitial: Color.white, colorEnding: Color.white)
                            } else if self.correctResponse {
                                Image(systemName: "hand.thumbsup.fill")
                                    .foregroundColor(.white)
                                    .transition(.opacity)
                                    .animation(.default)
                            } else {
                                Text(LocalizedStringKey("login"))
                                    .foregroundColor(.white)
                                    .font(.headline)
                            }
                            Spacer()
                        }
                        .padding(.all)
                    }
                    .disabled(self.email.isEmpty || self.password.isEmpty)
                    .opacity(self.email.isEmpty || self.password.isEmpty ? 0.5 : 1)
                    .background(Color("primary"))
                    .cornerRadius(15)
                    .frame(height: 50)
                }
                if self.correctResponse {
                    Text(LocalizedStringKey(self.responseMessage))
                        .foregroundColor(Color("primary"))
                        .font(.headline)
                        .transition(.scale)
                        .animation(.default)
                }
                if self.serverError == "server_error" {
                    Text(LocalizedStringKey(self.serverError))
                        .foregroundColor(.red)
                        .font(.headline)
                        .transition(.scale)
                        .animation(.default)
                }
            }
            .padding(.horizontal, 10.0)
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login(email: "", password: "", showModal: .constant(true))
    }
}
