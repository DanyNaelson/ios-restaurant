//
//  HorizontalDrinkList.swift
//  laostra
//
//  Created by Daniel Mejia on 05/10/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI

struct HorizontalDrinkList: View {
    var drinks: [Drink]
    var category: String
    var filter: String
    
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
                                ForEach(self.drinks, id: \.id) { drink in
                                    Group {
                                        if self.category == drink.category.name {
                                            DrinkCard(drink: drink)
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
