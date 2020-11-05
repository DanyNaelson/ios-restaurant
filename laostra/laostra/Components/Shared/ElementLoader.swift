//
//  ElementLoader.swift
//  laostra
//
//  Created by Daniel Mejia on 10/09/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI

struct ElementLoader: View {
    @State var animate = false
    @State var circleSize: CGFloat
    @State var colorInitial : Color
    @State var colorEnding : Color
    
    var body: some View {
        VStack {
            Circle()
                .trim(from: 0, to: 0.8)
                .stroke(AngularGradient(gradient: .init(colors: [self.colorInitial, self.colorEnding]), center: .center), style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .frame(width: self.circleSize, height: self.circleSize)
                .rotationEffect(.init(degrees: self.animate ? 360 : 0))
                .animation(Animation.linear(duration: 0.7).repeatForever(autoreverses: false))
        }
        .onAppear{
            self.animate.toggle()
        }
    }
}

struct ElementLoader_Previews: PreviewProvider {
    static var previews: some View {
        ElementLoader(circleSize: 20, colorInitial: Color.white, colorEnding: Color.white)
    }
}
