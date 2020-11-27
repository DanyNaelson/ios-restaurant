//
//  ContentView.swift
//  laostra
//
//  Created by Daniel Mejia on 31/07/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI

struct Home: View {
    @State private var menuType: String = "DISHES"
    @ObservedObject var dishManager : DishManager
    @ObservedObject var drinkManager : DrinkManager
    @ObservedObject var orderManager : OrderManager
    
    var body: some View {
        return NavigationView {
            VStack(alignment: .leading) {
                Spacer()
                Picker(selection: self.$menuType, label: EmptyView()) {
                    Text(LocalizedStringKey("dishes"))
                        .tag("DISHES")
                    Text(LocalizedStringKey("drinks"))
                        .tag("DRINKS")
                }
                .pickerStyle(SegmentedPickerStyle())
                Spacer()
                if self.menuType == "DISHES" {
                    Dishes(dishManager: dishManager, orderManager: self.orderManager)
                        .transition(.opacity)
                        .animation(.spring())
                }
                if self.menuType == "DRINKS" {
                    Drinks(drinkManager: drinkManager, orderManager: self.orderManager)
                        .transition(.opacity)
                        .animation(.spring())
                }
            }
            .navigationBarTitle(Text(LocalizedStringKey("menu")), displayMode: .inline)
            .navigationBarItems(
                leading: Image("Image")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40),
                trailing: CartIcon(dishManager: self.dishManager, drinkManager: self.drinkManager, orderManager: self.orderManager)
            )
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Home(dishManager: DishManager(), drinkManager: DrinkManager(), orderManager: OrderManager())
    }
}
