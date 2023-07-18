import Foundation

class User: Codable {
    
    let name: String
    let password: String
    
    init(name: String, password: String) {
        self.name = name
        self.password = password
    }
}
