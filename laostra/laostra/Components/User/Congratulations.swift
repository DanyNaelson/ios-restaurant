//
//  Congratulations.swift
//  laostra
//
//  Created by Daniel Mejia on 29/10/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI
import SwiftyJSON

struct Congratulations: View {
    @State var isLoading : Bool = true
    @State var addedPromotion : Bool = false
    @State var errorMessage : String = ""
    @Binding var showModal : Bool
    @ObservedObject var userManager : UserManager
    @EnvironmentObject var appState : AppState
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Image("Image")
                .resizable()
                .cornerRadius(10)
                .aspectRatio(contentMode: .fit)
                .frame(width: 120)
            if self.addedPromotion {
                Text(LocalizedStringKey("you_got_discount"))
                    .foregroundColor(Color("primary"))
                    .font(.title)
                    .fontWeight(.bold)
                    .lineLimit(nil)
                Text(LocalizedStringKey("can_use_discount"))
                    .font(.headline)
                Button(action: {
                    withAnimation {
                        self.showModal = false
                    }
                }){
                    HStack {
                        Spacer()
                        Text(LocalizedStringKey("agreed"))
                            .foregroundColor(.white)
                            .font(.headline)
                        Spacer()
                    }
                    .padding(.all)
                }
                .background(Color("primary"))
                .cornerRadius(15)
                .frame(height: 50)
            } else {
                if self.isLoading {
                    ElementLoader(circleSize: 50, colorInitial: Color("primary"), colorEnding: Color("primary"))
                } else {
                    Text(LocalizedStringKey("error_adding_promotion"))
                        .foregroundColor(Color("primary"))
                        .font(.headline)
                        .fontWeight(.bold)
                        .lineLimit(nil)
                    Text(LocalizedStringKey(self.errorMessage))
                        .font(.headline)
                }
            }
        }
        .onAppear(){
            let date = Date()
            var dateComponent = DateComponents()
            dateComponent.month = 1
            let endDate = Calendar.current.date(byAdding: dateComponent, to: date)
            
            let promotion : NSDictionary = [
                "status": "ACTIVE",
                "name": "welcome_discount",
                "code": "WELCOME_OSTRA",
                "type": "percent",
                "value": 0.05,
                "description": "discount_description",
                "endDate": dateFormatter.string(from: endDate!),
                "startDate": dateFormatter.string(from: date)
            ]
            let ostraUserID = UserDefaults.standard.string(forKey: "ostraUserID")!
            
            self.userManager.addPromotion(userID: ostraUserID, promotion: promotion) { response in
                self.isLoading = false

                let data = JSON(response)

                if data["ok"] == true {
                    self.addedPromotion = true
                } else {
                    if data["err"]["message"] == "logout" {
                        logout(appState: self.appState)
                    }
                    
                    self.errorMessage = data["err"]["message"].string ?? ""
                }
            }
        }
    }
}

struct Congratulations_Previews: PreviewProvider {
    static var previews: some View {
        Congratulations(showModal: .constant(true), userManager: UserManager())
    }
}
