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
    @State var errorMessage : String = ""
    @Binding var viewNumber: Int
    @Binding var dish: Dish
    @FetchRequest(fetchRequest: CartItem.getItemsByOwner(ownerId: UserDefaults.standard.string(forKey: "ostraUserID") ?? ""), animation: Animation.easeIn) var cartItems : FetchedResults<CartItem>
    @ObservedObject var dishManager : DishManager
    @ObservedObject var drinkManager : DrinkManager
    @SwiftUI.Environment(\.managedObjectContext) var context
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            if self.cartItems.count > 0 {
                List {
                    ForEach(self.cartItems, id: \.self){ cartItem in
                        CartItemCard(cartItem: cartItem, viewNumber: self.$viewNumber, dish: self.$dish, dishManager: self.dishManager)
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
        .padding(.vertical, 60)
    }
}

struct Cart_Previews: PreviewProvider {
    static var previews: some View {
        Cart(viewNumber: .constant(1), dish: .constant(Dish(id: "", status: "", picture: "", name: "", nickname: "", category: CategoryDish(name: "", nickname: "", order: 1), price: 0, description: "")), dishManager: DishManager(), drinkManager: DrinkManager())
    }
}
