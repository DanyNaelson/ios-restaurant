//
//  PromotionRow.swift
//  laostra
//
//  Created by Daniel Mejia on 29/10/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI
import ExytePopupView

struct PromotionRow: View {
    var promotion : Promotion
    @State var showingPopup : Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: "tag.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(Color("primary"))
            Text(promotion.code)
                .font(.headline)
                .foregroundColor(Color("textUnselected"))
                .padding(.leading, 10)
            Spacer()
        }
        .onTapGesture {
            self.showingPopup.toggle()
        }
        .popup(isPresented: $showingPopup, autohideIn: 5) {
            HStack {
                VStack(alignment: .center, spacing: 5){
                    HStack(alignment: .center, spacing: 10){
                        Image(systemName: "info.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color.blue)
                        Text("Info:")
                            .font(.headline)
                            .foregroundColor(Color.blue)
                    }
                    Text(LocalizedStringKey(promotion.name))
                        .font(.headline)
                        .foregroundColor(Color("textUnselected"))
                    Text(LocalizedStringKey(promotion.status))
                        .font(.headline)
                        .foregroundColor(promotion.status == "ACTIVE" ? Color.green : Color.red)
                    Text(LocalizedStringKey(promotion.description))
                        .font(.headline)
                        .foregroundColor(Color("textUnselected"))
                        .lineLimit(nil)
                }
            }
            .frame(height: 250)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("primary").opacity(0.5))
            .cornerRadius(10)
            .padding(20)
        }
    }
}

struct PromotionRow_Previews: PreviewProvider {
    static var previews: some View {
        PromotionRow(promotion: Promotion(_id: "567567576", status: "ACTIVE", name: "welcome_discount", code: "WELCOME_OSTRA", type: "percent", value: Int(0.05), description: "discount_description", endDate: Date(), startDate: Date()))
    }
}
