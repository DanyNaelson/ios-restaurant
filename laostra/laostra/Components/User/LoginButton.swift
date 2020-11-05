//
//  LoginButton.swift
//  laostra
//
//  Created by Daniel Mejia on 20/08/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI

struct LoginButton: View {
    @Binding var viewNumber : Int
    
    var body: some View {
        HStack {
            Button(action: {
                withAnimation {
                    self.viewNumber = 3
                }
            }){
                HStack {
                    Spacer()
                    Text(LocalizedStringKey("login"))
                        .foregroundColor(.white)
                        .font(.headline)
                    Spacer()
                }
                .padding(.all)
            }
            .background(Color("primary"))
            .cornerRadius(15)
            .frame(height: 50)
        }
        .shadow(color: .gray, radius: 5, x: 1, y: 1)
    }
}
