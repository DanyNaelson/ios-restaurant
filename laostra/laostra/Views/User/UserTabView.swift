//
//  UserTabView.swift
//  laostra
//
//  Created by Daniel Mejia on 05/11/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI
import SwiftyJSON

struct UserTabView: View {
    @State private var showModal = false
    @State var user : User
    @EnvironmentObject var appState : AppState
    @SwiftUI.Environment(\.managedObjectContext) var context
    
    var body: some View {
        TabView(selection:self.$appState.tabNumber) {
            Home()
                .tabItem{
                    Image(systemName: "book.fill")
                    Text(LocalizedStringKey("menu"))
            }
            .tag(1)
            Orders()
                .tabItem{
                    Image(systemName: "list.bullet")
                    Text(LocalizedStringKey("orders"))
            }
            .tag(2)
            .onAppear{
                if !self.appState.isUserLogged || self.appState.userManager.user.id == "" {
                    DispatchQueue.main.async {
                        self.showModal = true
                    }
                }
            }
            .sheet(isPresented: self.$showModal) {
                LoginMenu(showModal: self.$showModal).environmentObject(self.appState).environment(\.managedObjectContext, context)
            }
            Promotions()
                .tabItem{
                    Image(systemName: "tag.fill")
                    Text(LocalizedStringKey("promotions"))
            }
            .tag(3)
            .onAppear{
                if !self.appState.isUserLogged || self.appState.userManager.user.id == "" {
                    DispatchQueue.main.async {
                        self.showModal = true
                    }
                }
            }
            .sheet(isPresented: self.$showModal) {
                LoginMenu(showModal: self.$showModal).environmentObject(self.appState).environment(\.managedObjectContext, context)
            }
            Profile()
                .tabItem{
                    Image(systemName: "person.fill")
                    Text(LocalizedStringKey("profile"))
            }
            .tag(4)
            .onAppear{
                if !self.appState.isUserLogged || self.appState.userManager.user.id == "" {
                    DispatchQueue.main.async {
                        self.showModal = true
                    }
                }
            }
            .sheet(isPresented: self.$showModal) {
                LoginMenu(showModal: self.$showModal).environmentObject(self.appState).environment(\.managedObjectContext, context)
            }
        }
        .accentColor(Color.white)
        .onAppear{
            if self.appState.isUserLogged {
                let ostraUserID = UserDefaults.standard.string(forKey: "ostraUserID")!

                self.appState.userManager.getProfile(userID: ostraUserID){ response in
                    let data = JSON(response)

                    if data["ok"] == false {
                        if data["err"]["message"] == "logout" {
                            logout(appState: self.appState)
                        }
                    }
                }
            }
        }
    }
}

struct UserTabView_Previews: PreviewProvider {
    static var previews: some View {
        UserTabView(user: User(id: "", email: "", zipCode: "", role: "USER", nickname: "", confirm: false, birthday: Date(), cellPhone: "", gender: "FEMALE", google: false, facebook: false, withEmail: false, photo: "", favoriteDrinks: [], favoriteDishes: [], promotions: []))
    }
}
