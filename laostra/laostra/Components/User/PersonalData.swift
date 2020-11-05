//
//  PersonalData.swift
//  laostra
//
//  Created by Daniel Mejia on 01/10/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI
import SwiftyJSON
import Combine

struct PersonalData: View {
    @State private var gender : String = ""
    @State private var zipCode : String = ""
    @State private var birthday : Date = Date()
    @State private var showDatePicker : Bool = false
    @State private var errorField : String = ""
    @State private var errorMessage : String = ""
    @State private var correctResponse : Bool = false
    @State private var responseMessage : String = ""
    @State private var serverError : String = ""
    @Binding var step : Int
    @ObservedObject var userManager : UserManager
    @EnvironmentObject var appState : AppState
    var validationField : ValidationField = ValidationField()
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    func setErrors(validation: ValidationField) -> Void {
        self.errorField = validation.errorField
        self.errorMessage = validation.errorMessage
    }
    
    func updateProfile() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        // MARK: - Validate zipCode
        self.setErrors(validation: self.validationField.validateZipCode(value: self.zipCode))
        guard self.validationField.validateZipCode(value: self.zipCode).isValid else { return }

        self.appState.elementShow = true
        self.errorField = ""
        self.errorMessage = ""
        let ostraUserID = UserDefaults.standard.string(forKey: "ostraUserID")!
        let body = [
            "zipCode": self.zipCode,
            "gender": self.gender,
            "birthday": self.birthday
        ] as [String : Any]
        
        self.userManager.updateProfile(userID: ostraUserID, body: body){ response in
            let data = JSON(response)

            if data["ok"] == true {
                self.correctResponse = true
                
                Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
                    self.step = 2
                }
            } else {
                if data["err"]["message"] == "logout" {
                    logout(appState: self.appState)
                }
                print(data)
                self.errorField = data["err"]["field"].string ?? ""
                self.errorMessage = data["err"]["message"].string ?? ""
            }
            
            self.appState.elementShow = false
        }
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .center, spacing: 20) {
                Text(LocalizedStringKey("gender"))
                Picker(selection: $gender, label: EmptyView()) {
                    Text(LocalizedStringKey("female"))
                        .tag("FEMALE")
                    Text(LocalizedStringKey("male"))
                        .tag("MALE")
                }
                .pickerStyle(SegmentedPickerStyle())
                TextField(LocalizedStringKey("zip_code"), text: self.$zipCode, onEditingChanged: { (changed) in
                    if !changed {
                        self.setErrors(validation: self.validationField.validateZipCode(value: self.zipCode))
                    }
                })
                    .padding(20)
                    .background(self.errorField == "zipCode" ? Color.red.opacity(0.25) : Color(red: 0.94, green: 0.94, blue: 0.96, opacity: 0.5))
                    .cornerRadius(5)
                    .keyboardType(.numberPad)
                    .transition(.fade)
                    .animation(.default)
                if self.errorField == "zipCode" {
                    ErrorField(errorMessage: self.errorMessage)
                }
                VStack(alignment: .center, spacing: 20) {
                    Text(LocalizedStringKey("birthday"))
                    if self.errorField == "birthday" {
                        ErrorField(errorMessage: self.errorMessage)
                    }
                    Button(action: {
                        self.showDatePicker = true
                    }){
                        HStack {
                            Spacer()
                            Image(systemName: "hand.thumbsup.fill")
                                .foregroundColor(.white)
                                .transition(.opacity)
                                .animation(.default)
                            Text("\(self.birthday, formatter: dateFormatter)")
                                .foregroundColor(Color("primary"))
                                .font(.headline)
                            Spacer()
                        }
                        .padding(.all)
                    }
                    .background(Color.white)
                    .cornerRadius(5)
                    .border(Color("primary"), width: 1)
                }
                if self.showDatePicker {
                    Button(action: {
                        self.showDatePicker = false
                    }){
                        Text(LocalizedStringKey("done"))
                    }
                    DatePicker("", selection: self.$birthday, in: ...Date(), displayedComponents: .date)
                        .frame(width: 120)
                }
                HStack {
                    Button(action: {
                        self.updateProfile()
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
                                Text(LocalizedStringKey("save"))
                                    .foregroundColor(.white)
                                    .font(.headline)
                            }
                            Spacer()
                        }
                        .padding(.all)
                    }
                    .disabled(self.zipCode.isEmpty)
                    .opacity(self.zipCode.isEmpty ? 0.5 : 1)
                    .background(Color("primary"))
                    .cornerRadius(15)
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
            .onAppear(){
                self.zipCode = userManager.user.zipCode
                self.gender = userManager.user.gender
                self.birthday = userManager.user.birthday
            }
            .onTapGesture{
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
}

struct PersonalData_Previews: PreviewProvider {
    static var previews: some View {
        PersonalData(step: .constant(1), userManager: UserManager())
    }
}
