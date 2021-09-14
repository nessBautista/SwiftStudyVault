//
//  RatingsView.swift
//  PizzaApp
//
//  Created by Nestor Hernandez on 20/06/21.
//

import SwiftUI

struct RatingsView: View {
    var body: some View {
        HStack {
            ForEach(0..<4){ item in
                Image("Pizza Slice")
            }
        }
    }
}


struct RatingsView_Previews: PreviewProvider {
    static var previews: some View {
        RatingsView()
    }
}
