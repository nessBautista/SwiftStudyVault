import Foundation

// This random delay simulates being part of a bigger app
public func randomDelay(maxDuration: Double) {
  //  let randomWait = arc4random_uniform(UInt32(maxDuration * Double(USEC_PER_SEC)))
  let randomWait = UInt32.random(in: 0..<UInt32(maxDuration * Double(USEC_PER_SEC)))
  usleep(randomWait)
}
public func duration(_ block: () -> ()) -> TimeInterval {
  let startTime = Date()
  block()
  return Date().timeIntervalSince(startTime)
}
