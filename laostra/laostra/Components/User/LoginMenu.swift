//
//  LoginMenu.swift
//  laostra
//
//  Created by Daniel Mejia on 18/08/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI
import SwiftyJSON
import GoogleSignIn

struct LoginMenu: View {
    @State private var viewNumber = 1
    @State private var noCode = true
    @State private var loaderFacebook = false
    @Binding var showModal : Bool
    @EnvironmentObject var appState : AppState
    
    var body: some View {
        ZStack {
            ZStack {
                HStack(alignment: .top) {
                    if self.viewNumber == 2 || self.viewNumber == 3 {
                        Image(systemName: "arrowshape.turn.up.left")
                            .foregroundColor(Color("primary"))
                            .font(.title)
                            .onTapGesture {
                                hideKeyboard()
                                withAnimation {
                                    self.viewNumber = 1
                                }
                        }
                        .transition(.opacity)
                        .padding()
                    }
                    Spacer()
                    Image(systemName: "xmark.circle")
                        .foregroundColor(.red)
                        .font(.title)
                        .onTapGesture {
                            withAnimation {
                                self.showModal.toggle()
                                self.appState.tabNumber = 1
                            }
                    }
                    .transition(.opacity)
                    .padding()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            VStack(alignment: .center, spacing: 20) {
                Spacer()
                if self.viewNumber < 5 {
                    Image("Image")
                        .resizable()
                        .cornerRadius(10)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120)
                }
                
                switch self.viewNumber {
                case 1:
                    VStack(alignment: .center, spacing: 20) {
                        LoginButton(viewNumber: self.$viewNumber)
                        AppleButton(viewNumber: self.$viewNumber, showModal: self.$showModal)
                        FacebookButton(viewNumber: self.$viewNumber, showModal: self.$showModal)
                        GoogleButton(viewNumber: self.$viewNumber, showModal: self.$showModal)
                        VStack(spacing: 0) {
                            Text(LocalizedStringKey("click_to_register"))
                            Text(LocalizedStringKey("here"))
                                .foregroundColor(Color("primary"))
                                .bold()
                                .onTapGesture {
                                    withAnimation {
                                        self.viewNumber = 2
                                    }
                            }
                        }
                    }
                    .transition(.scale)
                case 2:
                    SignUp(email: "", password: "", viewNumber: self.$viewNumber, noCode: self.$noCode)
                        .transition(.scale)
                case 3:
                    Login(email: "", password: "", showModal: self.$showModal)
                        .transition(.scale)
                case 4:
                    ConfirmationCode(viewNumber: self.$viewNumber, noCode: self.$noCode)
                        .transition(.scale)
                case 5:
                    Discount(showModal: self.$showModal)
                default:
                    VStack(alignment: .center, spacing: 20) {
                        LoginButton(viewNumber: self.$viewNumber)
                        AppleButton(viewNumber: self.$viewNumber, showModal: self.$showModal)
                        FacebookButton(viewNumber: self.$viewNumber, showModal: self.$showModal)
                        GoogleButton(viewNumber: self.$viewNumber, showModal: self.$showModal)
                        VStack(spacing: 0) {
                            Text(LocalizedStringKey("click_to_register"))
                            Text(LocalizedStringKey("here"))
                                .foregroundColor(Color("primary"))
                                .bold()
                                .onTapGesture {
                                    withAnimation {
                                        self.viewNumber = 2
                                    }
                            }
                        }
                    }
                    .transition(.scale)
                }
                 Spacer()
            }
            .padding(.horizontal, 40.0)
            .padding(.top, 20.0)
            .onTapGesture{
                hideKeyboard()
            }
            if self.appState.fullScreenShow {
                GeometryReader {_ in
                    FullScreenLoader()
                }
                .background(Color.black.opacity(0.45).edgesIgnoringSafeArea(.all))
            }
        }
        .allowsHitTesting(!self.appState.elementShow)
    }
}

struct LoginMenu_Previews: PreviewProvider {
    static var previews: some View {
        LoginMenu(showModal: .constant(true)).environmentObject(AppState())
    }
}
