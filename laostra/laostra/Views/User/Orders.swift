//
//  Orders.swift
//  laostra
//
//  Created by Daniel Mejia on 05/08/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI
import SwiftyJSON

struct Orders: View {
    @State var orders : [ Order ] = []
    @EnvironmentObject var appState : AppState
    
    var body: some View {
        NavigationView {
            HStack() {
                if self.appState.isUserLogged {
                    VStack(alignment: .leading) {
                        List(self.orders, id: \.id) { order in
                            NavigationLink(destination: OrderDetail(order: order)){
                                OrderRow(order: order)
                            }
                        }
                        .padding(.top, 20)
                    }
                    .navigationBarTitle(Text(LocalizedStringKey("orders")), displayMode: .inline)
                    .navigationBarItems(
                        leading: Image("Image")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40),
                        trailing: CartIcon()
                    )
                } else {
                    EmptyView()
                }
            }
            .onAppear{
                if self.appState.isUserLogged {
                    self.appState.orderManager.getOrdersByUser{ response in
                        let json = JSON(response)
                        
                        if json["ok"] == true {
                            self.orders = self.appState.orderManager.orders
                        }
                    }
                }
            }
        }
    }
}

struct Orders_Previews: PreviewProvider {
    static var previews: some View {
        Orders()
    }
}
