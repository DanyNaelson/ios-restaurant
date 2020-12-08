//
//  WaiterProfile.swift
//  laostra
//
//  Created by Daniel Mejia on 05/08/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI
import Combine

struct WaiterProfile: View {
    @State var modal : Bool = false
    @Binding var selection : Int
    @ObservedObject var drinkManager : DrinkManager
    @ObservedObject var dishManager : DishManager
    @EnvironmentObject var appState : AppState
    
    var body: some View {
        let user = self.appState.userManager.user

        return NavigationView {
            HStack() {
                if self.appState.isUserLogged && user.id != "" {
                    VStack(alignment: .center) {
                        Text(user.nickname)
                        Button(action: {
                            logout(appState: self.appState)
                            self.selection = 1
                        }){
                            HStack(alignment: .center) {
                                Spacer()
                                Text(LocalizedStringKey("logout"))
                                    .foregroundColor(Color("primary"))
                                Image(systemName: "arrowshape.turn.up.left.fill")
                                    .foregroundColor(Color("primary"))
                                Spacer()
                            }
                            .background(Color.white)
                        }
                    }
                    .navigationBarTitle(Text(LocalizedStringKey("profile")), displayMode: .inline)
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

struct WaiterProfile_Previews: PreviewProvider {
    static var previews: some View {
        WaiterProfile(selection: .constant(4), drinkManager: DrinkManager(), dishManager: DishManager())
    }
}
