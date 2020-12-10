//
//  Profile.swift
//  laostra
//
//  Created by Daniel Mejia on 05/08/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI
import SwiftyJSON
import Combine

struct Profile: View {
    @State var modal : Bool = false
    @EnvironmentObject var appState : AppState
    
    var body: some View {
        let user = self.appState.userManager.user
        
        return NavigationView {
            HStack() {
                if self.appState.isUserLogged && user.id != "" {
                    VStack(alignment: .center) {
                        Text(user.nickname)
                        Button(action: {
                            self.modal = true
                        }){
                            HStack(alignment: .center) {
                                Spacer()
                                Text(LocalizedStringKey("preferences"))
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .background(Color("primary"))
                        }
                        Button(action: {
                            logout(appState: self.appState)
                            self.appState.tabNumber = 1
                        }){
                            HStack(alignment: .center) {
                                Spacer()
                                Text(LocalizedStringKey("logout"))
                                    .foregroundColor(Color("primary"))
                                Image(systemName: "arrowshape.turn.up.left.fill")
                                    .foregroundColor(Color("primary"))
                                Spacer()
                            }
                            .background(Color.white)
                        }
                    }
                    .navigationBarTitle(Text(LocalizedStringKey("profile")), displayMode: .inline)
                    .navigationBarItems(
                        leading: Image("Image")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40),
                        trailing: CartIcon()
                    )
                } else {
                    EmptyView()
                }
            }
            .sheet(isPresented: self.$modal) {
                Discount(showModal: self.$modal).environmentObject(self.appState)
            }
        }
        .onAppear{
            if self.appState.isUserLogged {
                let ostraUserID = UserDefaults.standard.string(forKey: "ostraUserID")!

                self.appState.userManager.getProfile(userID: ostraUserID){ response in
                    let data = JSON(response)

                    if data["ok"] == false {
                        if data["err"]["message"] == "logout" {
                            logout(appState: self.appState)
                            self.appState.tabNumber = 1
                        }
                    }
                }
            }
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
