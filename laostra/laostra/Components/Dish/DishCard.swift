//
//  DishCard.swift
//  laostra
//
//  Created by Daniel Mejia on 07/08/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct DishCard: View {
    var dish: Dish
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                ImageFromUrl(imageUrl: dish.picture)
                    .frame(width: 100, height: 120)
                    .clipped()
                    .background(Color.white)
                Group {
                    VStack(alignment: .leading) {
                        Text("\(dish.name)")
                            .padding(5)
                        Text("$ \(dish.price)")
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
