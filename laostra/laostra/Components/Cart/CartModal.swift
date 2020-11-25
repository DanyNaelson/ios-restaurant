//
//  CartModal.swift
//  laostra
//
//  Created by Daniel Mejia on 18/11/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI

struct CartModal: View {
    @State var dish : Dish = Dish(id: "", status: "", picture: "", name: "", nickname: "", category: CategoryDish(name: "", nickname: "", order: 1), price: 0, description: "")
    @State var drink : Drink = Drink(id: "", status: "", picture: "", name: "", nickname: "", category: CategoryDrink(name: "", nickname: "", order: 1), price: 0, description: "", specifications: "")
    @State var viewNumber: Int = 1
    @Binding var showModal: Bool
    @ObservedObject var dishManager : DishManager
    @ObservedObject var drinkManager : DrinkManager
    
    var body: some View {
        ZStack {
            ZStack {
                HStack(alignment: .top) {
                    if self.viewNumber == 1 {
                        EditButton()
                            .padding(15)
                    }
                    if self.viewNumber == 2 {
                        Image(systemName: "arrowshape.turn.up.left")
                            .foregroundColor(Color("primary"))
                            .font(.title)
                            .onTapGesture {
                                hideKeyboard()
                                withAnimation {
                                    self.viewNumber = 1
                                }
                        }
                        .transition(.opacity)
                        .padding()
                    }
                    Spacer()
                    Image(systemName: "xmark.circle")
                        .foregroundColor(.red)
                        .font(.title)
                        .onTapGesture {
                            withAnimation {
                                self.showModal.toggle()
                            }
                    }
                    .transition(.opacity)
                    .padding()
                }
            }
            .zIndex(2)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            if self.viewNumber == 1 {
                Cart(viewNumber: self.$viewNumber, dish: self.$dish, drink: self.$drink, dishManager: DishManager(), drinkManager: DrinkManager())
            }
            
            if self.viewNumber == 2 {
                if self.dish.id != "" {
                    DishDetail(dish: self.$dish, showModal: self.$showModal, dishManager: self.dishManager)
                } else if self.drink.id != "" {
                    DrinkDetail(drink: self.$drink, showModal: self.$showModal, drinkManager: self.drinkManager)
                }
            }
            
            if self.viewNumber == 3 {
                DishDetail(dish: self.$dish, showModal: self.$showModal, dishManager: self.dishManager)
            }
            
            if self.viewNumber == 4 {
                DrinkDetail(drink: self.$drink, showModal: self.$showModal, drinkManager: self.drinkManager)
            }
        }
    }
}

struct CartModal_Previews: PreviewProvider {
    static var previews: some View {
        CartModal(showModal: .constant(true), dishManager: DishManager(), drinkManager: DrinkManager())
    }
}
