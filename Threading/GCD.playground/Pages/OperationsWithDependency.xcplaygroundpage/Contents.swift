//: [Previous](@previous)
// This example uses Operations to download an image and apply a filter.
// This operation is done with a chain of operations which are linked via Dependencies.
// This also occurs inside a tableview to exemplify a practical case.
// We also practice the cancelling of operations. We need to take into account the propper way of cleaning
//Finally we improve the performance of our table view by applying the cancel method to cells off screen
// so only visible cells can use the resources.
import UIKit
import PlaygroundSupport

protocol ImageDataProvider {
    var image: UIImage? { get }
}
final class NetworkImageOperation: AsyncOperation {
    var image: UIImage?
    private var task: URLSessionDataTask?
    private let url: URL
    private let completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    
    init(url: URL, completionHandler: ((Data?, URLResponse?, Error?) -> Void)? = nil) {
        self.url = url
        self.completionHandler = completionHandler
        super.init()
    }
    
    convenience init?(string: String, completionHandler: ((Data?, URLResponse?, Error?) -> Void)? = nil) {
        guard let url = URL(string: string) else { return nil }
        self.init(url: url, completionHandler: completionHandler)
    }
    
    override func main() {
        task = URLSession.shared.dataTask(with: url) { [weak self]
            data, response, error in
            
            guard let self = self else { return }
            
            defer { self.state = .finished }
            guard !self.isCancelled else {
                print(">>> Cancelling NetworkImageOperation")
                return
            }
            if let completionHandler = self.completionHandler {
                completionHandler(data, response, error)
                return
            }
            
            guard error == nil, let data = data else { return }
            
            self.image = UIImage(data: data)
        }
        task?.resume()
    }
    
    override func cancel() {
        super.cancel()
        self.task?.cancel()
    }
}
extension NetworkImageOperation: ImageDataProvider {}

final class TiltShiftOperation: Operation {
    private static let context = CIContext()
    var outputImage: UIImage?
    private let inputImage: UIImage?
    
    init(image: UIImage? = nil) {
        inputImage = image
        super.init()
    }
    
    override func main() {
        let dependencyImage = dependencies
            .compactMap({($0 as? ImageDataProvider)?.image})
            .first
        guard let inputImage = inputImage ?? dependencyImage else { return }
        
        guard let filter = TiltShiftFilter(image: inputImage),
              let output = filter.outputImage else {
            print("Failed to generate tilt shift image")
            return
        }
        // check if Canceled every time you're about to perform a heavy operation
        guard !self.isCancelled else {
            print(">>>>>>Cancelling TiltShiftOperation")
            return
        }
        let fromRect = CGRect(origin: .zero, size: inputImage.size)
        guard
            let cgImage = TiltShiftOperation.context.createCGImage(output, from: fromRect),
            let rendered = cgImage.rendered()
        else {
            print("No image generated")
            return
        }
        // check if Canceled every time you're about to perform a heavy operation
        guard !self.isCancelled else {
            print(">>>>>>Cancelling TiltShiftOperation")
            return
        }
        outputImage = UIImage(cgImage: rendered)
    }
}
extension TiltShiftOperation: ImageDataProvider {
    var image: UIImage? { outputImage }
}

extension CGImage {
    func rendered()-> CGImage? {
        guard let colorSpace = self.colorSpace else {
            return nil
        }
        
        guard let context = CGContext(
                data: nil,
                width: width,
                height: height,
                bitsPerComponent: bitsPerComponent,
                bytesPerRow: bytesPerRow,
                space: colorSpace,
                bitmapInfo: bitmapInfo.rawValue)
        else {
            return nil
        }
        
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        context.draw(self, in: rect)
        return context.makeImage()
    }
}

class TiltShiftTableViewController: UITableViewController {
    private let queue = OperationQueue()
    private var urls: [URL] = []
    private var operations:[IndexPath: [Operation]] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(PhotoCell.self, forCellReuseIdentifier: "PhotoCell")
        guard let plist = Bundle.main.url(forResource: "Photos", withExtension: "plist"),
              let contents = try? Data(contentsOf: plist),
              let serial = try? PropertyListSerialization.propertyList(from: contents, format: nil),
              let serialUrls = serial as? [String] else {
            print("Something went horribly wrong!")
            return
        }
        
        urls = serialUrls.compactMap { URL(string: $0) }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        urls.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        300
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "PhotoCell") as? PhotoCell
        cell?.load(image: nil)
        
        let downloadOp = NetworkImageOperation(url: urls[indexPath.row])
        let tilsShiftOp = TiltShiftOperation()
        tilsShiftOp.addDependency(downloadOp)
        tilsShiftOp.completionBlock = {
            DispatchQueue.main.async {
                guard let cell = tableView.cellForRow(at: indexPath) as? PhotoCell else { return }
                print("got cell")
                tilsShiftOp.image
                cell.load(image: tilsShiftOp.image)
            }
        }
        queue.addOperation(downloadOp)
        queue.addOperation(tilsShiftOp)
        
        //If an operation for this indexPath already exist,
        //cancel it and store the new operation for that index
        if let existingOperations = operations[indexPath] {
            for operation in existingOperations {
                operation.cancel()
            }
        }
        operations[indexPath] = [tilsShiftOp, downloadOp]
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // If a cell goes off screen, you cancel the operation for that cell
        // so only visible cells uses the device resources.
        if let operations = self.operations[indexPath] {
            for operation in operations {
                operation.cancel()
            }
        }
    }
}



let vc = TiltShiftTableViewController()
vc.view.frame = CGRect(x: 0, y: 0, width: 300, height: 600)
PlaygroundPage.current.liveView = vc
PlaygroundPage.current.needsIndefiniteExecution = true



//: [Next](@next)
