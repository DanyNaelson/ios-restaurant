//
//  DrinkCard.swift
//  laostra
//
//  Created by Daniel Mejia on 05/10/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct DrinkCard: View {
    @State var drink: Drink
    @State var showModal : Bool = false
    @EnvironmentObject var appState : AppState
    @SwiftUI.Environment(\.managedObjectContext) var context
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                AnimatedImage(url: URL(string: drink.picture))
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(5)
                    .frame(width: 100, height: 120)
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 0)
                Group {
                    VStack(alignment: .leading) {
                        Text("\(drink.name)")
                            .padding(5)
                    }
                }
                .foregroundColor(Color("textUnselected"))
                .font(Font.headline.weight(.bold))
            }
            .sheet(isPresented: self.$showModal) {
                CartModal(drink: self.drink, viewNumber: 4, showModal: self.$showModal)
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

struct DrinkCard_Previews: PreviewProvider {
    static var previews: some View {
        DrinkCard(drink: Drink(id: "565765", status: "ACTIVE", picture: "", name: "Don Julio 70", nickname: "don-julio-70", category: CategoryDrink(name: "Tequila", nickname: "tequila", order: 1), price: 110, description: "Don Julio 70", specifications: ""))
    }
}
