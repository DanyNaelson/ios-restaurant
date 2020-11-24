//
//  FavoriteDrinkCard.swift
//  laostra
//
//  Created by Daniel Mejia on 06/10/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct FavoriteDrinkCard: View {
    @State var drink : Drink
    var favoriteDrinks : [ FavoriteDrink ]
    var fillFavoriteDrinks : (_ drink: Drink) -> Void

    var body: some View {
        ZStack {
            ZStack(alignment: .trailing) {
                if drink.selected {
                    Image(systemName: "checkmark.rectangle.fill")
                        .resizable()
                        .background(Color.white)
                        .foregroundColor(Color("primary"))
                        .frame(width: 40, height: 30, alignment: .top)
                        .font(Font.title.weight(.ultraLight))
                        .offset(x: 15.0, y: -15.0)
                }
            }
            .zIndex(1)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .transition(.fade)
            .animation(.default)
            VStack(alignment: .leading) {
                AnimatedImage(url: URL(string: drink.picture))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .cornerRadius(5)
                    .padding(.bottom, 6)
                Text("\(drink.name)")
                    .font(.caption)
                    .lineLimit(1)
                    .foregroundColor(Color("primary"))
            }
        }
        .padding(15)
        .border(Color("primary"), width: 1)
        .contentShape(Rectangle())
        .onTapGesture {
            self.fillFavoriteDrinks(drink)
            
            if favoriteDrinks.count < 3 {
                drink.selected.toggle()
            } else {
                if drink.selected {
                    drink.selected.toggle()
                }
            }
        }
        .onAppear(){
            let index = self.favoriteDrinks.firstIndex{ $0._id == drink.id }
            self.drink.selected = index != nil ? true : false
        }
    }
}
