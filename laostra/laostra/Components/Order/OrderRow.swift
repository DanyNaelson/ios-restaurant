//
//  OrderRow.swift
//  laostra
//
//  Created by Daniel Mejia on 27/11/20.
//  Copyright © 2020 Daniel Mejia. All rights reserved.
//

import SwiftUI

struct OrderRow: View {
    @State var order : Order
    
    var body: some View {
        Text("No Order: \(self.order.orderNum)")
    }
}

struct OrderRow_Previews: PreviewProvider {
    static var previews: some View {
        OrderRow(order: Order(id: "", orderNum: "676678687", status: "ORDERED", total: 0, ownerId: "67686876", orderItems: []))
    }
}
