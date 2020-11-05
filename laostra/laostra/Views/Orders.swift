//
//  Orders.swift
//  laostra
//
//  Created by Daniel Mejia on 05/08/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI

struct Orders: View {
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
                        trailing: Image(systemName: "cart.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
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
        Orders()
    }
}
