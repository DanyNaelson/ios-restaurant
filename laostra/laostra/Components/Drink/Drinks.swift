//
//  Drinks.swift
//  laostra
//
//  Created by Daniel Mejia on 05/10/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI
import SwiftyJSON

struct Drinks: View {
    @State private var search: String = ""
    @State private var filter: String = ""
    @State var drinks: [ Drink ] = []
    @EnvironmentObject var appState : AppState

    var body: some View {
        let drinks = self.search == "" ? self.drinks : self.drinks.filter{$0.nickname.localizedCaseInsensitiveContains(self.search)}
        let categories = getDrinkCategories(drinks: drinks)
        
        return VStack {
            Search(search: $search)
            Spacer()
            if !categories.isEmpty {
                CategoryFilter(filter: $filter, filters: categories)
            }
            Spacer()
            ScrollView(.vertical, showsIndicators: false) {
                if !drinks.isEmpty {
                    ForEach(categories, id: \.self) { category in
                        HorizontalDrinkList(drinks: drinks, category: category, filter: self.filter)
                    }
                } else {
                    VStack(alignment: .center) {
                        Text(LocalizedStringKey("no_drinks"))
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
//            .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
//                .onEnded({ value in
//                    if value.translation.height > 0 && value.translation.width < 100 && value.translation.width > -100 {
//                        self.appState.drinkManager.getDrinks(query: ""){{ response in
//                            let json = JSON(response)
//
//                            if json["ok"] == true {
//                                self.drinks = self.appState.drinkManager.drinks
//                            }
//                        }
//                    }
//                })
//            )
        }
        .onAppear(){
            self.appState.drinkManager.getDrinks(query: ""){response in
                let json = JSON(response)
                
                if json["ok"] == true {
                    self.drinks = self.appState.drinkManager.drinks
                }
            }
        }
    }
}

struct Drinks_Previews: PreviewProvider {
    static var previews: some View {
        Drinks()
    }
}
