//
//  Discount.swift
//  laostra
//
//  Created by Daniel Mejia on 01/10/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI

struct Discount: View {
    @State var step : Int = 1
    @Binding var showModal : Bool
    @ObservedObject var userManager : UserManager
    @ObservedObject var drinkManager : DrinkManager
    @ObservedObject var dishManager : DishManager
    @EnvironmentObject var appState : AppState
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            if step == 1 {
                Text(LocalizedStringKey("get_discount"))
                    .foregroundColor(Color("primary"))
                    .font(.title)
                    .fontWeight(.bold)
                    .lineLimit(nil)
                Text(LocalizedStringKey("help_to_complete_your_profile"))
                    .font(.headline)
            }
            if step < 4 {
                Text(LocalizedStringKey("step_\(self.step)"))
                    .foregroundColor(Color("primary"))
                    .font(.title)
                    .fontWeight(.bold)
                    .lineLimit(nil)
            }
            switch self.step {
            case 1:
                PersonalData(step: self.$step, userManager: userManager)
            case 2:
                FavoriteDrinks(step: self.$step, userManager: userManager, drinkManager: drinkManager)
            case 3:
                FavoriteDishes(step: self.$step, userManager: userManager, dishManager: dishManager)
            case 4:
                Congratulations(showModal: self.$showModal, userManager: userManager)
            default:
                PersonalData(step: self.$step, userManager: userManager)
            }
        }
        .padding(.horizontal, 20.0)
        .padding(.top, 20.0)
    }
}

struct Discount_Previews: PreviewProvider {
    static var previews: some View {
        Discount(showModal: .constant(true), userManager: UserManager(), drinkManager: DrinkManager(), dishManager: DishManager())
    }
}
