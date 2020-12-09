//
//  MainTabView.swift
//  laostra
//
//  Created by Daniel Mejia on 05/08/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI
import SwiftyJSON

struct MainTabView: View {
    @EnvironmentObject var appState : AppState

    var body: some View {
        let user = self.appState.userManager.user

        return ZStack {
            Color("primary").edgesIgnoringSafeArea(.all)
            if user.role == "ADMIN" && self.appState.isUserLogged {
                AdminTabView()
            } else if user.role == "WAITER" && self.appState.isUserLogged {
                WaiterTabView()
            } else {
                UserTabView(user: user)
            }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
