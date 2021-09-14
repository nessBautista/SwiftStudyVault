//
//  WorldHistoryOfPizzaView.swift
//  PizzaApp
//
//  Created by Nestor Hernandez on 20/06/21.
//

import SwiftUI

struct WorldHistoryOfPizzaView: View {
    var body: some View {
        VStack{
            ContentHeaderView()
            PageTitleView(title: "Pizza History")
            HistoryListView()
        }
    }
}

struct WorldHistoryOfPizzaView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WorldHistoryOfPizzaView()
            WorldHistoryOfPizzaView()
                .colorScheme(.dark)
                .background(Color.black)
        }
        
    }
}
