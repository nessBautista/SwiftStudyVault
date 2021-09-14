//: [Previous](@previous)

import Foundation

example(of: "Blackjack") {
    func deal(_ cardCount: UInt){
        var deck = cards
        var cardsRemaining = 52
        var hand = Hand()
        
        for _ in 0..<cardCount {
            let randomIndex = Int.random(in: 0..<cardsRemaining)
            hand.append(deck[randomIndex])
            deck.remove(at: randomIndex)
            cardsRemaining -= 1
        }
    }
}

//: [Next](@next)
