//
//  FavoriteDishes.swift
//  laostra
//
//  Created by Daniel Mejia on 01/10/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI
import SwiftyJSON
import SDWebImageSwiftUI

struct FavoriteDishes: View {
    @State private var search: String = ""
    @State private var correctResponse : Bool = false
    @State private var favoriteDishes : [FavoriteDish] = []
    @Binding var step : Int
    @ObservedObject var userManager : UserManager
    @ObservedObject var dishManager : DishManager
    @EnvironmentObject var appState : AppState
    
    func fillFavoriteDishes(dish: Dish) -> Void {
        let index = self.favoriteDishes.firstIndex{ $0._id == dish.id }

        if index == nil {
            if self.favoriteDishes.count < 3 {
                let favoriteDish = FavoriteDish(_id: dish.id, picture: dish.picture, name: dish.name, category: dish.category.name, description: dish.description)
                self.favoriteDishes.append(favoriteDish)
            }
        } else {
            self.favoriteDishes.remove(at: index!)
        }
    }
    
    func saveFavoriteDishes() {
        let ostraUserID = UserDefaults.standard.string(forKey: "ostraUserID")!
        self.appState.elementShow = true
        
        self.userManager.updateUserPreferences(userID: ostraUserID, preferences: "dishes", body: self.favoriteDishes){ response in
            let data = JSON(response)
            
            if data["ok"] == true {
                self.correctResponse = true
                
                Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
                    self.step = 4
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
        let dishes = self.search == "" ? self.dishManager.dishes : self.dishManager.dishes.filter{$0.nickname.localizedCaseInsensitiveContains(self.search)}

        return VStack(alignment: .center, spacing: 20) {
            Text(LocalizedStringKey("select_3_drinks"))
                .font(.headline)
            HStack(alignment: .center, spacing: 10) {
                ForEach(0 ..< 3) { index in
                    if favoriteDishes.indices.contains(index) {
                        VStack(alignment: .leading) {
                            AnimatedImage(url: URL(string: self.favoriteDishes[index].picture))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .cornerRadius(5)
                                .padding(.bottom, 6)
                            Text(self.favoriteDishes[index].name)
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
                                Text(LocalizedStringKey("dish_\(index + 1)"))
                                    .font(.caption)
                            }
                            .padding(15)
                        }
                        .transition(.fade)
                        .animation(.default)
                    }
                }
            }
            if self.favoriteDishes.count == 3 {
                Button(action: {
                    self.saveFavoriteDishes()
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
                if !dishes.isEmpty {
                    DrinkGrid(columns: 3, list: dishes){ dish in
                        FavoriteDishCard(dish: dish, favoriteDishes: self.favoriteDishes, fillFavoriteDishes: self.fillFavoriteDishes(dish:))
                    }
                } else {
                    VStack(alignment: .center) {
                        Text(LocalizedStringKey("no_dishes"))
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
        }
        .onAppear() {
            self.dishManager.getDishes(query: ""){ response in }
            self.favoriteDishes = self.userManager.user.favoriteDishes
        }
    }
}

struct FavoriteDishes_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteDishes(step: .constant(3), userManager: UserManager(), dishManager: DishManager())
    }
}
