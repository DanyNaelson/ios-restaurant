//
//  Cart.swift
//  laostra
//
//  Created by Daniel Mejia on 10/11/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct Cart: View {
    @State var loading : Bool = false
    @State var correctResponse : Bool = false
    @State var errorMessage : String = ""
    @Binding var viewNumber: Int
    @Binding var dish: Dish
    @Binding var drink: Drink
    @FetchRequest(fetchRequest: CartItem.getItemsByOwner(ownerId: UserDefaults.standard.string(forKey: "ostraUserID") ?? ""), animation: Animation.easeIn) var cartItems : FetchedResults<CartItem>
    @ObservedObject var dishManager : DishManager
    @ObservedObject var drinkManager : DrinkManager
    @SwiftUI.Environment(\.managedObjectContext) var context
    
    func confirmOrder(){
        self.loading = true
        
        Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false) { timer in
            self.loading = false
            self.correctResponse = true
        }
    }
    
    var body: some View {
        let total = self.cartItems.reduce(0) { $0 + $1.total }
        
        return VStack(alignment: .center, spacing: 20) {
            if self.cartItems.count > 0 {
                List {
                    ForEach(self.cartItems, id: \.self){ cartItem in
                        CartItemCard(cartItem: cartItem, viewNumber: self.$viewNumber, dish: self.$dish, drink: self.$drink, dishManager: self.dishManager, drinkManager: self.drinkManager)
                    }
                    .onDelete{ index in
                        let cartItemToDelete = self.cartItems[index.first!]
                        self.context.delete(cartItemToDelete)
                        
                        do{
                            try self.context.save()
                        } catch let error as NSError {
                            self.errorMessage = error.localizedDescription
                        }
                    }
                }
                HStack {
                    Spacer()
                    Text("Total: ")
                        .foregroundColor(Color("textUnselected"))
                        .font(.title)
                    Text("$\(total)")
                        .foregroundColor(Color("primary"))
                        .font(.title)
                }
                .padding(.trailing, 20)
                Button(action: {
                    self.confirmOrder()
                }){
                    HStack {
                        Spacer()
                        if self.loading {
                            ElementLoader(circleSize: 20, colorInitial: Color.white, colorEnding: Color.white)
                        } else if self.correctResponse {
                            HStack {
                                Image(systemName: "hand.thumbsup.fill")
                                    .foregroundColor(.white)
                                    .transition(.opacity)
                                    .animation(.default)
                                Text(LocalizedStringKey("done"))
                                    .foregroundColor(.white)
                                    .font(.headline)
                            }
                        } else {
                            Text(LocalizedStringKey("make_an_order"))
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                        Spacer()
                    }
                    .padding(.all)
                }
                .background(Color("primary"))
                .cornerRadius(10)
                .frame(height: 50)
            } else {
                Image(systemName: "cart.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color("primary"))
                    .frame(width: 100)
                Text(LocalizedStringKey("cart_is_empty"))
                    .foregroundColor(Color("textUnselected"))
                    .font(.headline)
            }
        }
        .padding(.top, 60)
    }
}

struct Cart_Previews: PreviewProvider {
    static var previews: some View {
        Cart(viewNumber: .constant(1), dish: .constant(Dish(id: "", status: "", picture: "", name: "", nickname: "", category: CategoryDish(name: "", nickname: "", order: 1), price: 0, description: "")), drink: .constant(Drink(id: "", status: "", picture: "", name: "", nickname: "", category: CategoryDrink(name: "", nickname: "", order: 1), price: 0, description: "", specifications: "")), dishManager: DishManager(), drinkManager: DrinkManager())
    }
}
