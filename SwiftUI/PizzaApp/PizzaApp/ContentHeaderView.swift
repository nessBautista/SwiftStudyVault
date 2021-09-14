//
//  ContentHeaderView.swift
//  PizzaApp
//
//  Created by Nestor Hernandez on 20/06/21.
//

import SwiftUI

struct ContentHeaderView: View {
    var body: some View {
        VStack {
            ZStack {
                Image("Surf Board")
                .resizable()
                .scaledToFit()
                Text("Huli Pizza Company")
                    .font(.title)
                    .foregroundColor(.white)
            }
        }
    }
}

struct ContentHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ContentHeaderView()
    }
}

