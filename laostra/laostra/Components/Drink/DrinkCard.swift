//
//  DrinkCard.swift
//  laostra
//
//  Created by Daniel Mejia on 05/10/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct DrinkCard: View {
    var drink: Drink
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                AnimatedImage(url: URL(string: drink.picture))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 120)
                Group {
                    VStack(alignment: .leading) {
                        Text("\(drink.name)")
                            .padding(5)
                        Text("$ \(drink.price)")
                            .padding(5)
                    }
                }
                .background(Color("primary"))
                .foregroundColor(Color.white)
            }
        }
        .frame(width: 150, height: 200)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 0)
    }
}

struct DrinkCard_Previews: PreviewProvider {
    static var previews: some View {
        DrinkCard(drink: Drink(id: "565765", status: "ACTIVE", picture: "", name: "Don Julio 70", nickname: "don-julio-70", category: CategoryDrink(name: "Tequila", nickname: "tequila", order: 1), price: 110, description: "Don Julio 70", specifications: ""))
    }
}
