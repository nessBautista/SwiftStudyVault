//
//  ContentView.swift
//  Drawings
//
//  Created by Nestor Hernandez on 20/06/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.yellow.edgesIgnoringSafeArea(.all)
            Circle()
                .inset(by: 10)
                .stroke(lineWidth: 20)
                .opacity(0.4)
                .foregroundColor(.blue)
                .background(Circle()
                                .foregroundColor(.green))
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
