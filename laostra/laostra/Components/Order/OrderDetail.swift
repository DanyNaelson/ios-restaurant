//
//  OrderDetail.swift
//  laostra
//
//  Created by Daniel Mejia on 27/11/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct OrderDetail: View {
    @State var order : Order
    
    var body: some View {
        let total = self.order.orderItems.reduce(0) { $0 + $1.total }
        
        return VStack(alignment: .center, spacing: 20) {
            List(self.order.orderItems, id: \.name) { orderItem in
                HStack {
                    AnimatedImage(url: URL(string: orderItem.picture))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                    VStack(alignment: .leading, spacing: 10) {
                        Text(orderItem.name)
                            .font(.headline)
                        Text("$\(orderItem.price) x \(orderItem.quantity)")
                            .font(.subheadline)
                            .foregroundColor(Color("primary"))
                            .multilineTextAlignment(.leading)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                    HStack {
                        Spacer()
                        VStack {
                            Spacer()
                            Text("Subtotal: $\(orderItem.total)")
                                .font(.headline)
                                .foregroundColor(Color("primary"))
                                .multilineTextAlignment(.trailing)
                        }
                    }
                    Spacer()
                }
            }
            HStack {
                Spacer()
                Text("Total: ")
                    .foregroundColor(Color("textUnselected"))
                    .font(.title)
                Text("$\(total)")
                    .foregroundColor(Color("primary"))
                    .font(.title)
            }
            .padding(.trailing, 20)
        }
        .navigationBarTitle("No Order: \(order.orderNum)", displayMode: .inline)
    }
}

struct OrderDetail_Previews: PreviewProvider {
    static var previews: some View {
        OrderDetail(order: Order(id: "", orderNum: "676678687", status: "ORDERED", total: 0, ownerId: "67686876", orderItems: []))
    }
}
