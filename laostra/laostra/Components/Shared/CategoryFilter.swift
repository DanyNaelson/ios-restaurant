//
//  CategoryFilter.swift
//  laostra
//
//  Created by Daniel Mejia on 05/08/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI

struct CategoryFilter: View {
    @Binding var filter: String
    var filters: [String]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center) {
                ForEach(filters, id: \.self) { filterOne in
                    VStack(alignment: .center) {
                        Image(systemName: toCategoryFormat(category: filterOne) == self.filter ? "stop.fill" : "stop")
                            .onTapGesture {
                                self.filter = toCategoryFormat(category: filterOne) == self.filter ? "" : toCategoryFormat(category: filterOne)
                            }
                        .font(.system(size: 40, weight: .ultraLight))
                        .foregroundColor(Color("primary"))
                        Text(filterOne)
                            .font(.subheadline)
                            .foregroundColor(Color("textAccent"))
                    }
                    .padding(10)
                }
            }
        }
    }
}
