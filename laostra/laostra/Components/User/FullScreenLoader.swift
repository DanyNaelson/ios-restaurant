//
//  FullScreenLoader.swift
//  laostra
//
//  Created by Daniel Mejia on 10/09/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI

struct FullScreenLoader: View {
    @State var animate = false
    
    var body: some View {
        VStack {
            Circle()
                .trim(from: 0, to: 0.8)
                .stroke(AngularGradient(gradient: .init(colors: [Color("primary"), Color("textUnselected")]), center: .center), style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .frame(width: 45, height: 45)
                .rotationEffect(.init(degrees: self.animate ? 360 : 0))
                .animation(Animation.linear(duration: 0.7).repeatForever(autoreverses: false))
            Text(LocalizedStringKey("loading"))
                .padding(.top)
                .foregroundColor(Color("textUnselected"))
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(15)
        .onAppear{
            self.animate.toggle()
        }
    }
}

struct FullScreenLoader_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenLoader()
    }
}
