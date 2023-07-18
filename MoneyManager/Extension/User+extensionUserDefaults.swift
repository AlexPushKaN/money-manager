import Foundation

extension User {
    
    static let userDefaultsKey = "userDefaultsKey"
    
    static func save(user: User) {
        let data = try? JSONEncoder().encode(user)
        UserDefaults.standard.set(data, forKey: userDefaultsKey)
    }
    
    static func loadUser() -> User? {
        
        var user: User?
        
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey) {
            user = try? JSONDecoder().decode(User.self, from: data)
        }
        
        return user
    }
}
