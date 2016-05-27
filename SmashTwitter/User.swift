import Foundation

public class User {
    public let screenName: String
    public let name: String
    public let id: String
    public let verified: Bool
    public let profileImageURL: NSURL?
    
    public init(screenName: String, name: String, id: String, verified: Bool, profileImageURL: NSURL? = nil) {
        self.screenName = screenName
        self.name = name
        self.id = id
        self.verified = verified
        self.profileImageURL = profileImageURL
    }
}