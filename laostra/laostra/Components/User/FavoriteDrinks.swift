//
//  FavoriteDrinks.swift
//  laostra
//
//  Created by Daniel Mejia on 01/10/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI
import SwiftyJSON

struct FavoriteDrinks: View {
    @State private var search: String = ""
    @State private var correctResponse : Bool = false
    @State private var favoriteDrinks : [FavoriteDrink] = []
    @Binding var step : Int
    @ObservedObject var userManager : UserManager
    @ObservedObject var drinkManager : DrinkManager
    @EnvironmentObject var appState : AppState
    
    func fillFavoriteDrinks(drink: Drink) -> Void {
        let index = self.favoriteDrinks.firstIndex{ $0._id == drink.id }

        if index == nil {
            if self.favoriteDrinks.count < 3 {
                let favoriteDrink = FavoriteDrink(_id: drink.id, picture: drink.picture, name: drink.name, category: drink.category.name, description: drink.description)
                self.favoriteDrinks.append(favoriteDrink)
            }
        } else {
            self.favoriteDrinks.remove(at: index!)
        }
    }
    
    func saveFavoriteDrinks() -> Void {
        let ostraUserID = UserDefaults.standard.string(forKey: "ostraUserID")!
        self.appState.elementShow = true
        
        self.userManager.updateUserPreferences(userID: ostraUserID, preferences: "drinks", body: self.favoriteDrinks){ response in
            let data = JSON(response)
            
            if data["ok"] == true {
                self.correctResponse = true
                
                Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
                    self.step = 3
                }
            } else {
                if data["err"]["message"] == "logout" {
                    logout(appState: self.appState)
                }
            }
            
            self.appState.elementShow = false
        }
    }

    var body: some View {
        let drinks = self.search == "" ? self.drinkManager.drinks : self.drinkManager.drinks.filter{$0.nickname.localizedCaseInsensitiveContains(self.search)}

        return VStack(alignment: .center, spacing: 20) {
            Text(LocalizedStringKey("select_3_drinks"))
                .font(.headline)
            HStack(alignment: .center, spacing: 10) {
                ForEach(0 ..< 3) { index in
                    if favoriteDrinks.indices.contains(index) {
                        VStack(alignment: .leading) {
                            ImageFromUrl(imageUrl: self.favoriteDrinks[index].picture)
                                .frame(width: 80, height: 80)
                                .cornerRadius(5)
                                .padding(.bottom, 6)
                            Text(self.favoriteDrinks[index].name)
                                .font(.caption)
                        }
                        .padding(15)
                        .transition(.fade)
                        .animation(.default)
                    } else {
                        VStack(alignment: .trailing) {
                            VStack(alignment: .center) {
                                Image(systemName: "plus.circle.fill")
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(Color("primary"))
                                    .font(.title)
                                    .cornerRadius(5)
                                    .border(Color("primary"), width: 1)
                                Text(LocalizedStringKey("drink_\(index + 1)"))
                                    .font(.caption)
                            }
                            .padding(15)
                        }
                        .transition(.fade)
                        .animation(.default)
                    }
                }
            }
            if self.favoriteDrinks.count == 3 {
                Button(action: {
                    self.saveFavoriteDrinks()
                }){
                    HStack {
                        Spacer()
                        if self.appState.elementShow {
                            ElementLoader(circleSize: 20, colorInitial: Color.white, colorEnding: Color.white)
                        } else if self.correctResponse {
                            Image(systemName: "hand.thumbsup.fill")
                                .foregroundColor(.white)
                                .transition(.opacity)
                                .animation(.default)
                        } else {
                            Text(LocalizedStringKey("save"))
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                        Spacer()
                    }
                    .padding(.all)
                }
                .background(Color("primary"))
                .cornerRadius(15)
            } else {
                Search(search: $search)
            }
            ScrollView(.vertical, showsIndicators: false) {
                if !drinks.isEmpty {
                    DrinkGrid(columns: 3, list: drinks){ drink in
                        FavoriteDrinkCard(drink: drink, favoriteDrinks: self.favoriteDrinks, fillFavoriteDrinks: self.fillFavoriteDrinks(drink:))
                    }
                } else {
                    VStack(alignment: .center) {
                        Text(LocalizedStringKey("no_drinks"))
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
        }
        .onAppear() {
            self.drinkManager.getDrinks(query: "")
            self.favoriteDrinks = self.userManager.user.favoriteDrinks
        }
    }
}

struct FavoriteDrinks_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteDrinks(step: .constant(2), userManager: UserManager(), drinkManager: DrinkManager())
    }
}
