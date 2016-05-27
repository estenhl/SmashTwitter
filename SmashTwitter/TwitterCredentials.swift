import Foundation

public class TwitterCredentials {
    public enum CredentialType {
        case FromFile
        case FromUser
    }
    
    private enum EncodingType {
        case RFC1738
        case base64
    }
    
    struct TwitterOAuthCredentialFiles {
        static let ConsumerKey = "~/projects/ios/consumerKey.txt"
        static let ConsumerSecret = "~/projects/ios/consumerSecret.txt"
        static let AccessToken = "~/projects/ios/accessToken.txt"
    }
    
    static func getTwitterConsumerCredentialString(type: CredentialType) -> String? {
        switch type {
        case .FromFile: return getCredentialsFromFile()
        default: return nil
        }
    }
    
    private static func getCredentialsFromFile() -> String? {
        if let consumerKey = readFile(TwitterOAuthCredentialFiles.ConsumerKey),
           let consumerSecret = readFile(TwitterOAuthCredentialFiles.ConsumerSecret) {
            var credentialString = consumerKey + ":" + consumerSecret
            credentialString = credentialString.toRFC1738()

            return credentialString.toBase64()
        }
        return nil
    }
    
    static func readFile(filename: String) -> String? {
        if filename == TwitterOAuthCredentialFiles.ConsumerKey {
            return ""
        } else if filename == TwitterOAuthCredentialFiles.ConsumerSecret {
            return ""
        } else if filename == TwitterOAuthCredentialFiles.AccessToken {
            return ""
        } else {
            return nil
        }
    }
}

extension String {
    func toRFC1738() -> String {
        return self
    }
    
    func toBase64() -> String? {
        let utf8str = self.dataUsingEncoding(NSUTF8StringEncoding)

        return utf8str?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
    }
}