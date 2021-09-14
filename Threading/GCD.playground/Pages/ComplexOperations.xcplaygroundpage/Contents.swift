//: [Previous](@previous)

import Foundation
import UIKit

let inputImage = UIImage(named: "dark_road_small.jpg")!

class TiltShiftOperation: Operation {
    private let inputImage: UIImage?
    private static let context = CIContext()
    
    var outputImage: UIImage?

    init(image: UIImage) {
        self.inputImage = image
        super.init()
    }
    
    override func main() {
        //start by filter the image
        guard let inputImage = inputImage,
              let filter = TiltShiftFilter(image: inputImage),
              let output = filter.outputImage else {
            return print("Failed to generate tilt shift image")
        }
        let fromRect = CGRect(origin: .zero, size: inputImage.size)
        guard let cgImage = TiltShiftOperation.context.createCGImage(output, from: fromRect) else {
            print("No image generated")
            return
        }
        outputImage = UIImage(cgImage: cgImage)
    }
}

let tsOp = TiltShiftOperation(image: inputImage)

duration {
    tsOp.start()
}
tsOp.outputImage

//: [Next](@next)
