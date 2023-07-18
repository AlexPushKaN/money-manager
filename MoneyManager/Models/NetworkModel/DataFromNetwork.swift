import Foundation

class DataFromNetwork: Codable {
    
    let disclaimer: String
    let license: String
    let timestamp: TimeInterval
    let base: String
    let rates: [String:Double]
}

