//
//  HistoryRowView.swift
//  PizzaApp
//
//  Created by Nestor Hernandez on 20/06/21.
//

import SwiftUI

struct HistoryRowView: View {
    var body: some View {
        HStack(alignment: .top) {
            Image("1_100w")
            Text("Huli Chicken")
            Spacer()
        }
    }
}


struct HistoryRowView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryRowView()
    }
}
