//
//  Orders.swift
//  laostra
//
//  Created by Daniel Mejia on 05/08/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI

struct Orders: View {
    @ObservedObject var dishManager : DishManager
    @ObservedObject var drinkManager : DrinkManager
    @EnvironmentObject var appState : AppState
    
    var body: some View {
        NavigationView {
            HStack() {
                if self.appState.isUserLogged {
                    VStack(alignment: .leading) {
                        Text(LocalizedStringKey("orders"))
                    }
                    .navigationBarTitle(Text(LocalizedStringKey("orders")), displayMode: .inline)
                    .navigationBarItems(
                        leading: Image("Image")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40),
                        trailing: CartIcon(dishManager: self.dishManager, drinkManager: self.drinkManager)
                    )
                } else {
                    EmptyView()
                }
            }
        }
    }
}

struct Orders_Previews: PreviewProvider {
    static var previews: some View {
        Orders(dishManager: DishManager(), drinkManager: DrinkManager())
    }
}
