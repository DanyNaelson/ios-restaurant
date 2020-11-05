//
//  Dishes.swift
//  laostra
//
//  Created by Daniel Mejia on 05/10/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI

struct Dishes: View {
    @State private var search: String = ""
    @State private var filter: String = ""
    @ObservedObject var dishManager : DishManager

    var body: some View {
        let dishes = self.search == "" ? self.dishManager.dishes : self.dishManager.dishes.filter{$0.nickname.localizedCaseInsensitiveContains(self.search)}
        let categories = getDishCategories(dishes: dishes)
        
        return VStack {
            Search(search: $search)
            Spacer()
            if !categories.isEmpty {
                CategoryFilter(filter: $filter, filters: categories)
            }
            Spacer()
            ScrollView(.vertical) {
                if !dishes.isEmpty {
                    ForEach(categories, id: \.self) { category in
                        HorizontalDishList(dishes: dishes, category: category, filter: self.filter)
                    }
                } else {
                    VStack(alignment: .center) {
                        Text(LocalizedStringKey("no_dishes"))
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                .onEnded({ value in
                    if value.translation.height > 0 && value.translation.width < 100 && value.translation.width > -100 {
                        self.dishManager.getDishes(query: "")
                    }
                })
            )
        }
        .onAppear(){
            self.dishManager.getDishes(query: "")
        }
    }
}

struct Dishes_Previews: PreviewProvider {
    static var previews: some View {
        Dishes(dishManager: DishManager())
    }
}
