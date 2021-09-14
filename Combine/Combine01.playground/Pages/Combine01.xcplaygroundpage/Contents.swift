import Foundation
import Combine

//Allocating your subscriptions in a collectionable, will allow your subscriptions to call the cancel() method when is about to be deallocated
var subscription = Set<AnyCancellable>()

example(of: "NotificationCenter") {
    let center = NotificationCenter.default
    let myNotification = Notification.Name("MyNotfication")
    let publisher = center.publisher(for: myNotification)
    
    let subscription = publisher
        .print()
        .sink { _ in
            print("Notification received from a publisher!")
        }
    
    center.post(name: myNotification, object: nil)
    subscription.cancel()
}

example(of: "Just") {
    let just = Just("Hello World")
    just
        .sink {_ in
            print("Received Completion")
        } receiveValue: {
            print("Received Value: ", $0)
        }

}

example(of: "assign(to:on)") {
    class SomeObject {
        var value: String = "" {
            didSet {
                print(value)
            }
        }
    }
    
    let object = SomeObject()
    ["Hello", "World!"].publisher
        .assign(to: \.value, on: object)
        .store(in: &subscription)
}

example(of: "PassthroughSubject") {
    let subject = PassthroughSubject<String, Never>()
    
    subject
        .sink(receiveValue: { print($0) })
        .store(in: &subscription)
    
    subject.send("Hello")
    subject.send("world")
    subject.send(completion: .finished)
    subject.send("still there?")
}

example(of: "CurrentValueSubject") {
    let subject = CurrentValueSubject<Int, Never>(0)
    subject
        .print()
        .sink(receiveValue: {print($0)})
        .store(in: &subscription)
    
    print(subject.value)
    subject.send(1)
    subject.send(2)
    print(subject.value)
    subject.send(completion: .finished)
}


example(of: "Type Erasure") {
    let subject = PassthroughSubject<Int, Never>()
    let publisher = subject.eraseToAnyPublisher()
    
    // This publisher is AnyPublisher<Int, Never>
    publisher
        .sink {print($0)}
        .store(in: &subscription)
    
    // And it does not allow to send values through it
    //publisher.send(0)
    // But you can send values throught the subject
    subject.send(0)
    
    // This allows you to keep hidden the publisher's details from the subscriber.
}
