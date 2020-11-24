//
//  CartItemCard.swift
//  laostra
//
//  Created by Daniel Mejia on 12/11/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import SwiftyJSON

struct CartItemCard: View {
    var cartItem : CartItem
    @Binding var viewNumber: Int
    @Binding var dish: Dish
    @ObservedObject var dishManager : DishManager
    @SwiftUI.Environment(\.managedObjectContext) var context
    
    var body: some View {
        HStack {
            AnimatedImage(url: URL(string: cartItem.photo))
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
            VStack(alignment: .leading, spacing: 10) {
                Text(cartItem.name)
                    .font(.headline)
                Text("$\(cartItem.price) x \(cartItem.quantity)")
                    .font(.subheadline)
                    .foregroundColor(Color("primary"))
                    .multilineTextAlignment(.leading)
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Text("Total: $\(cartItem.total)")
                        .font(.headline)
                        .foregroundColor(Color("primary"))
                        .multilineTextAlignment(.trailing)
                }
            }
            Spacer()
        }
        .onTapGesture {
            self.dishManager.getDish(id: cartItem.id){ resp in
                var dish = resp

                dish.quantity = Int(cartItem.quantity)
                self.dish = dish
                self.viewNumber = 2
            }
        }
    }
}

struct CartItemCard_Previews: PreviewProvider {
    static var previews: some View {
        CartItemCard(cartItem: CartItem(), viewNumber: .constant(1), dish: .constant(Dish(id: "", status: "", picture: "", name: "", nickname: "", category: CategoryDish(name: "", nickname: "", order: 1), price: 0, description: "")), dishManager: DishManager())
    }
}
