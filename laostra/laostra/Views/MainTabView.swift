//
//  MainTabView.swift
//  laostra
//
//  Created by Daniel Mejia on 05/08/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI
import SwiftyJSON

struct MainTabView: View {
    @State private var selection = 1
    @State private var showModal = false
    @EnvironmentObject var appState : AppState
    @ObservedObject var userManager = UserManager()
    @ObservedObject var dishManager = DishManager()
    @ObservedObject var drinkManager = DrinkManager()

    var body: some View {
        let user = self.userManager.user

        return ZStack {
            Color("primary").edgesIgnoringSafeArea(.all)
            TabView(selection:$selection) {
                Home(dishManager: dishManager, drinkManager: drinkManager)
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
                .onAppear(){
                    if !self.appState.isUserLogged || user.id == "" {
                        DispatchQueue.main.async {
                            self.showModal = true
                        }
                    }
                }
                .sheet(isPresented: self.$showModal) {
                    LoginMenu(selection: self.$selection, showModal: self.$showModal, userManager: userManager, drinkManager: drinkManager, dishManager: dishManager).environmentObject(self.appState)
                }
                Promotions(selection: self.$selection, userManager: userManager)
                    .tabItem{
                        Image(systemName: "tag.fill")
                        Text(LocalizedStringKey("promotions"))
                }
                .tag(3)
                .onAppear(){
                    if !self.appState.isUserLogged || user.id == "" {
                        DispatchQueue.main.async {
                            self.showModal = true
                        }
                    }
                }
                .sheet(isPresented: self.$showModal) {
                    LoginMenu(selection: self.$selection, showModal: self.$showModal, userManager: userManager, drinkManager: drinkManager, dishManager: dishManager).environmentObject(self.appState)
                }
                Profile(selection: self.$selection, userManager: userManager, drinkManager: drinkManager, dishManager: dishManager)
                    .tabItem{
                        Image(systemName: "person.fill")
                        Text(LocalizedStringKey("profile"))
                }
                .tag(4)
                .onAppear(){
                    if !self.appState.isUserLogged || user.id == "" {
                        DispatchQueue.main.async {
                            self.showModal = true
                        }
                    }
                }
                .sheet(isPresented: self.$showModal) {
                    LoginMenu(selection: self.$selection, showModal: self.$showModal, userManager: userManager, drinkManager: drinkManager, dishManager: dishManager).environmentObject(self.appState)
                }
            }
            .accentColor(Color.white)
            .onAppear(){
                if self.appState.isUserLogged {
                    let ostraUserID = UserDefaults.standard.string(forKey: "ostraUserID")!

                    self.userManager.getProfile(userID: ostraUserID){ response in
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
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
