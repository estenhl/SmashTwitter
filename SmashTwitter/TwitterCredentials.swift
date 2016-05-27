import Foundation

public class TwitterCredentials {
    struct TwitterOAuthCredentialFiles {
        static let ConsumerKey = "~/projects/ios/consumerKey.txt"
        static let ConsumerSecret = "~/projects/ios/consumerSecret.txt"
        static let AccessToken = "~/projects/ios/accessToken.txt"
        static let AccessTokenSecret = "~/projects/ios/accessTokenSecret.txt"
    }
    
    static func readCredentialsFromFile(filename: String) -> String? {
        if filename == TwitterOAuthCredentialFiles.ConsumerKey {
            return ""
        } else if filename == TwitterOAuthCredentialFiles.ConsumerSecret {
            return ""
        } else if filename == TwitterOAuthCredentialFiles.AccessToken {
            return ""
        } else if filename == TwitterOAuthCredentialFiles.AccessTokenSecret {
            return ""
        } else {
            return nil
        }
    }
}