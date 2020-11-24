//
//  FavoriteDishCard.swift
//  laostra
//
//  Created by Daniel Mejia on 08/10/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct FavoriteDishCard: View {
    @State var dish : Dish
    var favoriteDishes : [ FavoriteDish ]
    var fillFavoriteDishes : (_ dish: Dish) -> Void

    var body: some View {
        ZStack {
            ZStack(alignment: .trailing) {
                if dish.selected {
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
                AnimatedImage(url: URL(string: dish.picture))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .cornerRadius(5)
                    .padding(.bottom, 6)
                Text("\(dish.name)")
                    .font(.caption)
                    .lineLimit(1)
                    .foregroundColor(Color("primary"))
            }
        }
        .padding(15)
        .border(Color("primary"), width: 1)
        .contentShape(Rectangle())
        .onTapGesture {
            self.fillFavoriteDishes(dish)
            
            if favoriteDishes.count < 3 {
                dish.selected.toggle()
            } else {
                if dish.selected {
                    dish.selected.toggle()
                }
            }
        }
        .onAppear(){
            let index = self.favoriteDishes.firstIndex{ $0._id == dish.id }
            self.dish.selected = index != nil ? true : false
        }
    }
}
