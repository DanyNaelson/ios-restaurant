//
//  AdminTabView.swift
//  laostra
//
//  Created by Daniel Mejia on 05/11/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI

struct AdminTabView: View {
    @State private var selection = 1
    @State private var showModal = false
    @EnvironmentObject var appState : AppState
    @ObservedObject var userManager : UserManager
    @ObservedObject var dishManager = DishManager()
    @ObservedObject var drinkManager = DrinkManager()
    
    var body: some View {
        TabView(selection:$selection) {
            Home(dishManager: dishManager, drinkManager: drinkManager)
                .tabItem{
                    Image(systemName: "book.fill")
                    Text(LocalizedStringKey("menu"))
            }
            .tag(1)
            Store()
                .tabItem{
                    Image(systemName: "list.bullet")
                    Text(LocalizedStringKey("store"))
            }
            .tag(2)
            AdminProfile(selection: self.$selection, userManager: userManager, drinkManager: drinkManager, dishManager: dishManager)
                .tabItem{
                    Image(systemName: "person.fill")
                    Text(LocalizedStringKey("profile"))
            }
            .tag(3)
        }
        .accentColor(Color.white)
    }
}

struct AdminTabView_Previews: PreviewProvider {
    static var previews: some View {
        AdminTabView(userManager: UserManager())
    }
}
