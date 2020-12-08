//
//  ConfirmationCode.swift
//  laostra
//
//  Created by Daniel Mejia on 28/09/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import Combine
import SwiftUI
import Introspect
import SwiftyJSON

struct ConfirmationCode: View {
    @State var codeNumbers : Array<String> = ["", "", "", "", "", ""]
    @State var ostraCode : String = ""
    @State var codePosition : Int = 0
    @State var isLoading : Bool = false
    @State var correctCode : Bool = false
    @State var correctResponse : Bool = false
    @State var email : String = ""
    @State var emailError : String = ""
    @Binding var viewNumber : Int
    @Binding var noCode : Bool
    @EnvironmentObject var appState : AppState
    
    func resendCode() {
        hideKeyboard()
        self.appState.elementShow = true
        let ostraUserID = UserDefaults.standard.string(forKey: "ostraUserID")!

        self.appState.userManager.resendConfirmationCode(userID: ostraUserID, email: self.email){ response in
            self.appState.elementShow = false
            let data = JSON(response)

            if data["ok"] == true {
                self.correctResponse = true
                
                Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
                    self.noCode = false
                }
            } else {
                if data["err"]["message"] == "logout" {
                    logout(appState: self.appState)
                }
            }
        }
    }
    
    func sendCode() {
        if self.codeNumbers.joined(separator: "").count == 6 {
            hideKeyboard()
            self.isLoading = true
            self.ostraCode = self.codeNumbers.joined(separator: "")
            let ostraUserID = UserDefaults.standard.string(forKey: "ostraUserID")!

            self.appState.userManager.sendConfirmationCode(userID: ostraUserID, confirmationCode: self.ostraCode){ response in
                let data = JSON(response)

                if data["ok"] == true {
                    self.correctCode = true
                    
                    Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
                        self.viewNumber = 5
                    }
                } else {
                    if data["err"]["message"] == "logout" {
                        logout(appState: self.appState)
                    }
                }
                
                self.isLoading = false
            }
        }
    }
    
    var body: some View {
        let email = self.appState.userManager.user.email
        let pseudoEmail = "\(email.split(separator: "@")[0].prefix(3))*****@\(email.split(separator: "@")[1])"

        return ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .center, spacing: 20) {
                Text(LocalizedStringKey("confirmation_code"))
                    .foregroundColor(Color("primary"))
                    .font(.title)
                    .fontWeight(.bold)
                    .lineLimit(nil)
                if self.noCode {
                    VStack (alignment: .center, spacing: 20) {
                        Text(LocalizedStringKey("confirmation_code_not_sent"))
                            .font(.headline)
                        TextField(LocalizedStringKey("email"), text: $email)
                            .padding(20)
                            .background(self.emailError != "" ? Color.red.opacity(0.25) : Color(red: 0.94, green: 0.94, blue: 0.96, opacity: 0.5))
                            .transition(.fade)
                            .animation(.default)
                            .cornerRadius(5)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        HStack {
                            Button(action: {
                                self.resendCode()
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
                                        Text(LocalizedStringKey("send"))
                                            .foregroundColor(.white)
                                            .font(.headline)
                                    }
                                    Spacer()
                                }
                                .padding(.all)
                            }
                            .background(Color("primary"))
                            .cornerRadius(15)
                        }
                    }
                    .onAppear(){
                        self.email = email
                    }
                } else {
                    Text(LocalizedStringKey("confirmation_code_sent_\(pseudoEmail)"))
                        .font(.headline)
                    HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 15) {
                        ForEach(0 ..< self.codeNumbers.count) {index in
                            VStack {
                                TextField("0", text: Binding<String>(
                                    get: { self.codeNumbers[index] },
                                    set: {
                                        self.codeNumbers[index] = String($0.prefix(1))
                                        sendCode()
                                    }))
                                    .introspectTextField { textField in
                                        textField.font = UIFont.systemFont(ofSize: 35.0)
                                        textField.textColor = UIColor(named: "primary")
                                        textField.textAlignment = .center
                                        
                                        if index == self.codePosition {
                                            if self.ostraCode.count != 6 {
                                                textField.becomeFirstResponder()
                                            }
                                            
                                            if textField.text != "" {
                                                self.codePosition += 1
                                            }
                                        }
                                    }
                                    .keyboardType(.decimalPad)
                                    .font(Font.system(size: 35.0))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color("primary"))
                                    .onTapGesture(perform: {
                                        self.codeNumbers[index] = ""
                                    })
                                Rectangle()
                                    .frame(width: 30, height: 5, alignment: .bottom)
                                    .foregroundColor(self.codePosition == index ? Color("primary") : self.codeNumbers[index] == "" ? .red : Color("textUnselected"))
                            }
                        }
                    }
                    .padding(.vertical)
                }
                if self.isLoading {
                    ElementLoader(circleSize: 40, colorInitial: Color("primary"), colorEnding: Color("textUnselected"))
                } else if self.correctCode {
                    Image(systemName: "checkmark.rectangle.fill")
                        .resizable()
                        .frame(width: 80, height: 60, alignment: .center)
                        .foregroundColor(Color("primary"))
                        .transition(.opacity)
                        .animation(.default)
                    Text(LocalizedStringKey("confirmed_email"))
                        .foregroundColor(Color("primary"))
                        .font(.headline)
                        .transition(.scale)
                        .animation(.default)
                } else {
                    if self.ostraCode.count == 6 {
                        Text(LocalizedStringKey("incorrect_code"))
                            .foregroundColor(.red)
                            .font(.title)
                            .lineLimit(nil)
                            .transition(.scale)
                            .animation(.default)
                    }
                }
            }
            .padding(.horizontal, 10.0)
        }
    }
}

struct ConfirmationCode_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationCode(viewNumber: .constant(4), noCode: .constant(true))
    }
}
