//: [Previous](@previous)

import Foundation

public struct HashTable<Key:Hashable, Value> {
    private typealias Element = (key: Key, value: Value)
    private typealias Bucket = [Element]
    private var buckets: [Bucket]
    private(set) public var count = 0
    
    public var isEmpty: Bool {
        count == 0
    }
    
    public init(capacity: Int) {
        assert(capacity > 0)
        self.buckets = Array(repeating: [], count: capacity)

    }
    
    private func index(for key: Key) -> Int {
        abs(key.hashValue) % buckets.count
    }
    
    public subscript(key:Key) -> Value? {
        get {
            return value(for: key)
        }
        set {
            if let value = newValue {
                self.update(value: value, for: key)
            } else {
                self.removeValue(for: key)
            }
        }
    }
    
    public func value(for key: Key) -> Value? {
        let index = self.index(for: key)
        return buckets[index].first {$0.key == key}?.value
    }
    
    @discardableResult
    mutating func update(value: Value, for key: Key) -> Value? {
        //first get the index
        let index = index(for: key)
        
        //find for the value in the 2D array
        if let (idx, element) = self.buckets[index].enumerated().first(where: {$0.1.key == key}) {
            let oldValue = self.buckets[index][idx].value
            self.buckets[index][idx].value = value
            return oldValue
        }
        
        //IF the element is NOT there, that means it is a new one
        self.buckets[index].append((key, value))
        count += 1
        return nil
        
    }
    
    mutating func removeValue(for key: Key) -> Value? {
        let index = self.index(for: key)
        
        if let (idx, element) = self.buckets[index].enumerated().first(where: {$0.1.key == key}) {
            self.buckets[index].remove(at: idx)
            self.count -= 1
            
            return element.value
        }
        return nil
    }
}

var hashTable =  HashTable<String, String>(capacity: 5)
hashTable["firstName"] = "Nestor"
hashTable["LastName"] = "Hernandez"

print(hashTable["firstName"])
print(hashTable["LastName"])

print("Ok")
hashTable["LastName"] = nil
print(hashTable["LastName"])
//: [Next](@next)
