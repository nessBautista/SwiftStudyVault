//: [Previous](@previous)

import Foundation
import Combine

var subscriptions = Set<AnyCancellable>()
example(of: "collect") {
    ["A", "B", "C", "D", "E"].publisher
        .collect(2)
        .sink { completion in
            print(completion)
        } receiveValue: { item in
            print(item)
        }
        .store(in: &subscriptions)

}

example(of: "Map") {
    let formatter = NumberFormatter()
    formatter.numberStyle = .spellOut
    
    [123,4,56].publisher
        .map {
            formatter.string(from: NSNumber(integerLiteral: $0)) ?? String()
        }
        .sink (receiveValue: { print($0) })
        .store(in: &subscriptions)
}

example(of: "replaceNil") {
    ["A", nil, "C"].publisher
        .replaceNil(with: "-")
        .map({$0!})
        .sink(receiveValue: {print($0)})
        .store(in: &subscriptions)

}

example(of: "replaceEmpty") {
    let empty = Empty<Int, Never>()
    
    empty
        .replaceEmpty(with: 1)
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions)
}

example(of: "FlatMap") {
//    let charlotte = Chatter(name: "Charlotte", message: "Hi!, I'm Charlotte")
//    let james = Chatter(name: "James", message: "Hi!, I'm James")
//
//    let chat = CurrentValueSubject<Chatter, Never>(charlotte)
//
//    chat
//        .sink(receiveValue: {print($0.message.value)})
//        .store(in: &subscriptions)
//
//    charlotte.message.value = "Charlotte: How's it going?"
//    chat.value = james
    let charlotte = Chatter(name: "Charlotte", message: "Hi!, I'm Charlotte")
    let james = Chatter(name: "James", message: "Hi!, I'm James")
    
    let chat = CurrentValueSubject<Chatter, Never>(charlotte)
    chat
        .flatMap {$0.message}
        .sink(receiveValue: {print($0)})
        .store(in: &subscriptions)
    
    charlotte.message.value = "Charlotte: How's it going?"
    chat.value = james
    
    james.message.value = "James: Doing grat. You?"
    charlotte.message.value = "Charlotte:O'm doing fine thanks"
}
//: [Next](@next)
