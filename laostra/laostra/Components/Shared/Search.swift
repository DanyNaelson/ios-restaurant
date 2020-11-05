//
//  Search.swift
//  laostra
//
//  Created by Daniel Mejia on 03/08/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI

struct Search: View {
    @Binding var search: String
    
    var body: some View {
        VStack(alignment: .leading){
            HStack {
                Image(systemName: "magnifyingglass")
                    .padding()
                TextField(LocalizedStringKey("search"), text: $search)
            }
        }
    }
}
