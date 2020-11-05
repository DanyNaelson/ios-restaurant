//
//  ErrorField.swift
//  laostra
//
//  Created by Daniel Mejia on 02/11/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI

struct ErrorField: View {
    var errorMessage : String
    
    var body: some View {
        HStack {
            Image(systemName: "xmark.square.fill")
                .font(.footnote)
                .foregroundColor(.red)
                .transition(.scale)
                .animation(.default)
            Text(LocalizedStringKey(self.errorMessage))
                .font(.footnote)
                .foregroundColor(.red)
                .transition(.scale)
                .animation(.default)
        }
    }
}

struct ErrorField_Previews: PreviewProvider {
    static var previews: some View {
        ErrorField(errorMessage: "Error")
    }
}
