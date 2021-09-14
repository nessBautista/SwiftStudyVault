//
//  OrderRowView.swift
//  PizzaApp
//
//  Created by Nestor Hernandez on 20/06/21.
//

import SwiftUI

struct OrderRowView: View {
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("Your order item here")
            Spacer()
            Text("$0.00")
        }
    }
}

struct OrderRowView_Previews: PreviewProvider {
    static var previews: some View {
        OrderRowView()
    }
}
