//
//  WaiterTabView.swift
//  laostra
//
//  Created by Daniel Mejia on 05/11/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI

struct WaiterTabView: View {
    @State private var showModal = false
    @EnvironmentObject var appState : AppState
    
    var body: some View {
        TabView(selection:self.$appState.tabNumber) {
            Home()
                .tabItem{
                    Image(systemName: "book.fill")
                    Text(LocalizedStringKey("menu"))
            }
            .tag(1)
            WaiterOrders()
                .tabItem{
                    Image(systemName: "list.bullet")
                    Text(LocalizedStringKey("orders"))
            }
            .tag(2)
            WaiterProfile()
                .tabItem{
                    Image(systemName: "person.fill")
                    Text(LocalizedStringKey("profile"))
            }
            .tag(3)
        }
        .accentColor(Color.white)
    }
}

struct WaiterTabView_Previews: PreviewProvider {
    static var previews: some View {
        WaiterTabView()
    }
}
