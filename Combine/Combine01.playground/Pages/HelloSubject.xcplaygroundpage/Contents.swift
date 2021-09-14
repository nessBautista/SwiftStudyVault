//: [Previous](@previous)

import Foundation
import Combine

example(of: "PassthroughSubject") {
    // 1
      enum MyError: Error {
        case test
      }
    
    final class StringSubscriber: Subscriber {
        typealias Input = String
        typealias Failure = MyError
        
        func receive(subscription: Subscription){
            subscription.request(.max(2))
        }
        
        func receive(_ input: String) -> Subscribers.Demand {
            print("Received value", input)
            return input == "World" ? .max(1) : .none
        }
        
        func receive(completion: Subscribers.Completion<MyError>) {
            print("Received completion", completion)
        }
    }
    
    let subscriber = StringSubscriber()
    //Subscription 1
    let subject = PassthroughSubject<String, MyError>()
    subject.subscribe(subscriber)
    
    //Subscription 2
    let subscription = subject
        .sink(
            receiveCompletion: { completion in
                print("Received completion (sink)", completion)
            },
            receiveValue: { value in
                print("Received value (sink)", value)
            }
        )
    
    subject.send("Hello")
    subject.send("World")
    
    //First subscription is cancelled but the second one is still alive
    subscription.cancel()
    subject.send("Still there?")
    //But after completion, second subscription is also done
    subject.send(completion: .failure(MyError.test))

    subject.send(completion: .finished)
    subject.send("How about another one?")
}

example(of: "CurrentValueSubject") {
    // 1
    var subscriptions = Set<AnyCancellable>()
    
    // 2
    let subject = CurrentValueSubject<Int, Never>(0)
    
    // 3
    subject
        .print()
        .sink(receiveValue: { print($0) })
        .store(in: &subscriptions) // 4
    
    
    subject.send(1)
    subject.send(2)
    print("Subject Value:", subject.value)
    subject.value = 3
    print("Subject Value:", subject.value)
    
    subject
        .print()
      .sink(receiveValue: { print("Second subscription:", $0) })
      .store(in: &subscriptions)
}
//: [Next](@next)
