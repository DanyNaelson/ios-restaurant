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
    @EnvironmentObject var appState : AppState
    @SwiftUI.Environment(\.managedObjectContext) var context
    
    var body: some View {
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
                CartModal(showModal: self.$showModal, dishManager: self.dishManager, drinkManager: self.drinkManager)
                    .environmentObject(self.appState)
                    .environment(\.managedObjectContext, self.context)
            }
    }
}

struct CartIcon_Previews: PreviewProvider {
    static var previews: some View {
        CartIcon(dishManager: DishManager(), drinkManager: DrinkManager())
    }
}
