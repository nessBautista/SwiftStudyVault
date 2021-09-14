//
//  HistoryListView.swift
//  PizzaApp
//
//  Created by Nestor Hernandez on 20/06/21.
//

import SwiftUI

struct HistoryListView: View {
    var body: some View {
        List(0..<5){ item in
            HistoryRowView()
        }
    }
}

struct HistoryListView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryListView()
    }
}
