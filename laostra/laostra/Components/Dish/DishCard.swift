//
//  DishCard.swift
//  laostra
//
//  Created by Daniel Mejia on 07/08/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct DishCard: View {
    @State var dish: Dish
    @State var showModal : Bool = false
    @ObservedObject var dishManager : DishManager
    @ObservedObject var orderManager : OrderManager
    @EnvironmentObject var appState : AppState
    @SwiftUI.Environment(\.managedObjectContext) var context
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                AnimatedImage(url: URL(string: dish.picture))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 120)
                    .onTapGesture {
                        self.showModal.toggle()
                    }
                Group {
                    VStack(alignment: .leading) {
                        Text("\(dish.name)")
                            .padding(5)
                        Text("$ \(dish.price)")
                            .padding(5)
                    }
                }
                    .background(Color("primary"))
                    .foregroundColor(Color.white)
            }
            .sheet(isPresented: self.$showModal) {
                CartModal(dish: self.dish, viewNumber: 3, showModal: self.$showModal, dishManager: self.dishManager, drinkManager: DrinkManager(), orderManager: self.orderManager)
                    .environmentObject(self.appState)
                    .environment(\.managedObjectContext, self.context)
            }
        }
        .frame(width: 150, height: 200)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 0)
    }
}
