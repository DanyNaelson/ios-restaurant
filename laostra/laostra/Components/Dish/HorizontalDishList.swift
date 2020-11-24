//
//  HorizontalDishList.swift
//  laostra
//
//  Created by Daniel Mejia on 06/08/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI

struct HorizontalDishList: View {
    var dishes: [Dish]
    var category: String
    var filter: String
    @ObservedObject var dishManager : DishManager
    
    var body: some View {
        VStack {
            Group {
                if(filter == toCategoryFormat(category: category) || filter == ""){
                    Group {
                        Text(self.category)
                            .font(.headline)
                            .foregroundColor(filter == toCategoryFormat(category: category) ? Color.white : Color("primary"))
                            .padding(.vertical, 5)
                    }
                    .frame(maxWidth: .infinity)
                    .background(filter == toCategoryFormat(category: category) ? Color("primary") : Color.white.opacity(0))
                    .border(Color("primary"))
                    VStack(alignment: .leading) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(self.dishes, id: \.id) { dish in
                                    Group {
                                        if self.category == dish.category.name {
                                            DishCard(dish: dish, dishManager: self.dishManager)
                                        }
                                    }
                                }
                            }
                            .padding(0)
                        }
                    }
                }
            }
        }
    }
}
