//
//  MenuListView.swift
//  PizzaApp
//
//  Created by Nestor Hernandez on 20/06/21.
//

import SwiftUI

struct MenuListView: View {
    var body: some View {
        VStack {
            ListHeaderView(text: "Menu")
            List(0 ..< 5) { item in
                MenuRowView()
            }
        }
    }
}

struct MenuListView_Previews: PreviewProvider {
    static var previews: some View {
        MenuListView()
    }
}


