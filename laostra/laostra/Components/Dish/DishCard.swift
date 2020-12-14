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
    @EnvironmentObject var appState : AppState
    @SwiftUI.Environment(\.managedObjectContext) var context
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                AnimatedImage(url: URL(string: dish.picture))
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(5)
                    .frame(width: 100, height: 120)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 0)
                Group {
                    VStack(alignment: .leading) {
                        Text("\(dish.name)")
                            .padding(5)
                    }
                }
                .foregroundColor(Color("textUnselected"))
                .font(Font.headline.weight(.bold))
            }
            .sheet(isPresented: self.$showModal) {
                CartModal(dish: self.dish, viewNumber: 3, showModal: self.$showModal)
                    .environmentObject(self.appState)
                    .environment(\.managedObjectContext, self.context)
            }
        }
        .frame(width: 150, height: 200)
        .onTapGesture {
            self.showModal.toggle()
        }
    }
}

struct DishCard_Previews: PreviewProvider {
    static var previews: some View {
        DishCard(dish: Dish(id: "565765", status: "ACTIVE", picture: "", name: "Coctel de camarón", nickname: "coctel-de-camaron", category: CategoryDish(name: "Barra Fría", nickname: "barra-fria", order: 1), price: 90, description: "Coctel de camarón"))
    }
}
