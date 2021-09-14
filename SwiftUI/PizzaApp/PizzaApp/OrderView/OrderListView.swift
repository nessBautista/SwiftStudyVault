//
//  OrderListView.swift
//  PizzaApp
//
//  Created by Nestor Hernandez on 20/06/21.
//

import SwiftUI

struct OrderListView: View {
    var body: some View {
        VStack {
            ListHeaderView(text: "Your Order")
            List(0..<5) { item in
                
                OrderRowView()
            }
        }
    }
}

struct OrderListView_Previews: PreviewProvider {
    static var previews: some View {
        OrderListView()
    }
}


