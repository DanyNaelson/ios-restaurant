//
//  CartIcon.swift
//  laostra
//
//  Created by Daniel Mejia on 17/11/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI

struct CartIcon: View {
    @State var showModal = false
    @ObservedObject var dishManager : DishManager
    @ObservedObject var drinkManager : DrinkManager
    @ObservedObject var orderManager : OrderManager
    @EnvironmentObject var appState : AppState
    @SwiftUI.Environment(\.managedObjectContext) var context
    @FetchRequest(fetchRequest: CartItem.getItemsByOwner(ownerId: UserDefaults.standard.string(forKey: "ostraUserID") ?? ""), animation: Animation.easeIn) var cartItems : FetchedResults<CartItem>
    
    var body: some View {
        ZStack {
            if self.cartItems.count > 0 {
                ZStack {
                    Circle()
                        .foregroundColor(.red)
                        .frame(width: 15, height: 15)
                    Text("\(self.cartItems.count)")
                        .foregroundColor(.white)
                        .font(.system(size: 10))
                        .padding(5)
                }
                .offset(x: 20, y: -10)
            }
            Image(systemName: "cart.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
                .padding(.vertical, 15)
                .padding(.leading, 15)
                .padding(.trailing, 5)
                .onTapGesture {
                    self.showModal = true
                }
                .sheet(isPresented: self.$showModal){
                    CartModal(showModal: self.$showModal, dishManager: self.dishManager, drinkManager: self.drinkManager, orderManager: self.orderManager)
                        .environmentObject(self.appState)
                        .environment(\.managedObjectContext, self.context)
                }
        }
    }
}

struct CartIcon_Previews: PreviewProvider {
    static var previews: some View {
        CartIcon(dishManager: DishManager(), drinkManager: DrinkManager(), orderManager: OrderManager())
    }
}
