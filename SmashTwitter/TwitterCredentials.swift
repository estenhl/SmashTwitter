import Foundation

public class TwitterCredentials {
    struct TwitterOAuthCredentialFiles {
        static let ConsumerKey = "consumerKey"
        static let ConsumerSecret = "consumerSecret"
        static let AccessToken = "accessToken"
        static let AccessTokenSecret = "accessTokenSecret"
    }
    
    static func readCredentialsFromFile(filename: String) -> String? {
        let credentialPath = NSBundle.mainBundle().pathForResource(filename, ofType: "txt")
        if let credentialPath = credentialPath,
           let data = NSData(contentsOfFile: credentialPath) {
           return String(data: data, encoding: NSUTF8StringEncoding)
        }
        return nil
    }
}