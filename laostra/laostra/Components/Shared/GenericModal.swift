//
//  GenericModal.swift
//  laostra
//
//  Created by Daniel Mejia on 19/11/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI

struct GenericModal<Content: View>: View {
    @Binding var showModal: Bool
    var content: Content
    
    var body: some View {
        ZStack {
            ZStack {
                HStack(alignment: .top) {
                    Spacer()
                    Image(systemName: "xmark.circle")
                        .foregroundColor(.red)
                        .font(.title)
                        .onTapGesture {
                            withAnimation {
                                self.showModal.toggle()
                            }
                    }
                    .transition(.opacity)
                    .padding()
                }
            }
            .zIndex(2)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            self.content
        }
    }
}

struct GenericModal_Previews: PreviewProvider {
    static var previews: some View {
        GenericModal(showModal: .constant(true), content: Text("Modal"))
    }
}
