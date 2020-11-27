//
//  Promotions.swift
//  laostra
//
//  Created by Daniel Mejia on 29/10/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI

struct Promotions: View {
    @State var showNewView = false
    @State var promotions : [ Promotion ] = []
    @Binding var selection : Int
    @ObservedObject var userManager : UserManager
    @ObservedObject var dishManager : DishManager
    @ObservedObject var drinkManager : DrinkManager
    @ObservedObject var orderManager : OrderManager
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                if self.promotions.count > 0 {
                    List(self.promotions, id: \.code) { promotion in
                        PromotionRow(promotion: promotion)
                    }
                    .padding(.top, 20)
                } else {
                    VStack(alignment: .center) {
                        Text(LocalizedStringKey("no_promotions"))
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .onAppear(){
                self.promotions = self.userManager.user.promotions
            }
            .navigationBarTitle(Text(LocalizedStringKey("promotions")), displayMode: .inline)
            .navigationBarItems(
                leading: Image("Image")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40),
                trailing: CartIcon(dishManager: self.dishManager, drinkManager: self.drinkManager, orderManager: self.orderManager)
            )
        }
    }
}

struct Promotions_Previews: PreviewProvider {
    static var previews: some View {
        Promotions(selection: .constant(3), userManager: UserManager(), dishManager: DishManager(), drinkManager: DrinkManager(), orderManager: OrderManager())
    }
}
