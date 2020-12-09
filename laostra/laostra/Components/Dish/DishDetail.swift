//
//  DishDetail.swift
//  laostra
//
//  Created by Daniel Mejia on 10/11/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import Introspect

struct DishDetail: View {
    @State var textField : UITextField = UITextField()
    @State var cartItem : CartItem?
    @State var loading : Bool = false
    @State var correctResponse : Bool = false
    @State var errorMessage : String = ""
    @Binding var dish : Dish
    @Binding var showModal : Bool
    @EnvironmentObject var appState : AppState
    @SwiftUI.Environment(\.managedObjectContext) var context
    
    func addToCart(){
        self.loading = true
        
        if self.cartItem == nil {
            let userID = UserDefaults.standard.string(forKey: "ostraUserID") ?? "none"
            let newCartItem = CartItem(context: self.context)
            CartItem.updateCartItemByDish(newCartItem: newCartItem, dish: self.dish, userID: userID)
        } else {
            self.cartItem?.quantity = Int16(self.dish.quantity)
            self.cartItem?.total = Int16(self.cartItem!.price * self.cartItem!.quantity)
        }

        do {
            try self.context.save()
            self.correctResponse = true
            self.loading = false
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false){ timer in
                self.showModal.toggle()
            }
        } catch let error {
            self.errorMessage = error.localizedDescription
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            AnimatedImage(url: URL(string: dish.picture))
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
            Text(dish.name)
                .foregroundColor(Color("primary"))
                .font(.title)
            Text(dish.description)
                .foregroundColor(Color("textUnselected"))
                .font(.headline)
            HStack(alignment: .center, spacing: 20){
                Image(systemName: "minus.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color("primary"))
                    .onTapGesture {
                        if dish.quantity > 1 {
                            dish.quantity -= 1
                        }
                    }
                TextField(String(self.dish.quantity), text: Binding<String>(
                            get: { String(self.dish.quantity) },
                            set: {
                                if self.dish.quantity == 0 {
                                    self.dish.quantity = Int($0.prefix(1)) ?? 0
                                } else {
                                    self.dish.quantity = Int($0) ?? 0
                                }
                            }))
                    .frame(width: 25)
                    .keyboardType(.numberPad)
                    .foregroundColor(Color("textUnselected"))
                    .font(.headline)
                    .padding()
                    .introspectTextField{ textField in
                        self.textField = textField
                    }
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color("primary"))
                    .onTapGesture {
                        dish.quantity += 1
                    }
            }
            Spacer()
            Button(action: {
                self.addToCart()
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
                            Text(self.cartItem == nil ? LocalizedStringKey("added") : LocalizedStringKey("updated"))
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                    } else {
                        Text(self.cartItem == nil ? LocalizedStringKey("add_to_cart") : LocalizedStringKey("update_to_cart"))
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    Spacer()
                }
                .padding(.all)
            }
            .disabled(self.dish.quantity < 1 || self.loading || self.correctResponse)
            .opacity(self.dish.quantity < 1 ? 0.5 : 1)
            .background(Color("primary"))
            .cornerRadius(10)
            .frame(height: 50)
        }
        .padding(.top, 80)
        .padding(.horizontal, 50)
        .onAppear{
            let userID = UserDefaults.standard.string(forKey: "ostraUserID") ?? "none"
            
            do {
                let cartItem = try self.context.fetch(CartItem.getItemByIdAndByOwner(id: self.dish.id, ownerId: userID))
                
                if !cartItem.isEmpty {
                    dish.quantity = Int(cartItem[0].quantity)
                    self.cartItem = cartItem[0]
                } else {
                    dish.quantity = 0
                }
            } catch let error {
                fatalError("Failed to fetch entity: \(error)")
            }
        }
        .onTapGesture{
            hideKeyboard()
        }
    }
}

struct DishDetail_Previews: PreviewProvider {
    static var previews: some View {
        DishDetail(dish: .constant(Dish(id: "56757", status: "ACTIVE", picture: "", name: "Coctel de camarón", nickname: "coctel-de-camaron", category: CategoryDish(name: "Barra Fría", nickname: "barra-fria", order: 4), price: 150, description: "Coctel de camarón")), showModal: .constant(false))
    }
}
