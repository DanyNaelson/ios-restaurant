//
//  DishGrid.swift
//  laostra
//
//  Created by Daniel Mejia on 08/10/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI

struct DishGrid<Content: View, Drink>: View {
    private let columns: Int
    private var list: [[Dish]] = []
    private let content: (Dish) -> Content
    
    init(columns: Int, list: [Dish], @ViewBuilder content:@escaping (Dish) -> Content) {
        self.columns = columns
        self.content = content
        self.setupList(list: list)
    }
    
    private mutating func setupList(list: [Dish]) {
        var column = 0
        var columnIndex = 0
        
        for object in list {
            if columnIndex < self.columns {
                if columnIndex == 0 {
                    self.list.insert([object], at: column)
                    columnIndex += 1
                } else {
                    self.list[column].append(object)
                    columnIndex += 1
                }
            } else {
                column += 1
                self.list.insert([object], at: column)
                columnIndex = 1
            }
        }
    }
    
    var body: some View {
        VStack {
            ForEach(0 ..< self.list.count, id: \.self) { i  in
                HStack {
                    ForEach(0 ..< self.list[i].count, id: \.self) { index in
                        self.content(self.list[i][index])
                    }
                }
            }
        }
    }
}
