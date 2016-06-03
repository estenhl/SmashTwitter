import Foundation

public class OAuth {
    public static let Versions = [
    "Twitter": "1.0"
    ]
    
    public static let SignatureMethods = [
    "Twitter": "HMAC-SHA1"
    ]
    
    static func generateNonce(key: String) -> String {
        return "ACGABCAG"
    }
    
    static func generateTimestamp() -> String {
        let date = NSDate()
        
        return String(Int(date.timeIntervalSince1970))
    }
}

public extension OAuth {
    static func generateSignature(parameters: [String: String], url: String, httpMethod: String) -> String? {
        let encodedParameters = encodeParameters(parameters)
        var parameterString = generateParameterString(encodedParameters)

        if let encodedUrl = url.toRFC3986(),
           let encodedParameterString = parameterString.toRFC3986(),
           let accessTokenKey = TwitterCredentials.readCredentialsFromFile(TwitterCredentials.TwitterOAuthCredentialFiles.AccessTokenSecret),
           let consumerKey = TwitterCredentials.readCredentialsFromFile(TwitterCredentials.TwitterOAuthCredentialFiles.ConsumerSecret ){
            parameterString = httpMethod.uppercaseString + "&" + encodedUrl + "&" + encodedParameterString
            print(parameterString)
            let data = parameterString.encodeWithHmacSha1(consumerKey + "&" + accessTokenKey)
            let options = NSDataBase64EncodingOptions()
            return data.base64EncodedStringWithOptions(options)
        }
        
        return nil
    }
    
    private static func encodeParameters(parameters: [String: String]) -> [String: String] {
        var encodedParameters = [String: String]()
        for (key, value) in parameters {
            if let encodedKey = key.toRFC3986(),
               let encodedValue = value.toRFC3986() {
                encodedParameters[encodedKey] = encodedValue
            }
        }
        
        return encodedParameters
    }
        
    private static func generateParameterString(parameters: [String: String]) -> String {
        let sortedParameters = sortParameters(parameters)
        
        var parameterString = ""
        var count = 0
        for (key, value) in sortedParameters {
            parameterString += key + "=" + value
            count += 1
            if count != parameters.count {
                parameterString += "&"
            }
        }

        return parameterString
    }
    
    private static func sortParameters(parameters: [String: String]) -> [(String, String)] {
        return parameters.sort() { $0.0 < $1.0 }
    }
}

public extension OAuth {
    static func createHeaderFromParameters(parameters: [String: String], withSignature signature: String) -> String {
        let consumerKey = parameters["oauth_consumer_key"] ?? ""
        let nonce = parameters["oauth_nonce"] ?? ""
        let signatureMethod = parameters["oauth_signature_method"] ?? ""
        let timestamp = parameters["oauth_timestamp"] ?? ""
        let token = parameters["oauth_token"] ?? ""
        let version = parameters["oauth_version"] ?? ""
        
        return "OAuth " +
               "oauth_consumer_key=\"\(consumerKey)\", " +
               "oauth_nonce=\"\(nonce)\", " +
               "oauth_signature=\"\(signature)\", " +
               "oauth_signature_method=\"\(signatureMethod)\", " +
               "oauth_timestamp=\"\(timestamp)\", " +
               "oauth_token=\"\(token)\", " +
               "oauth_version=\"\(version)\""
    }
}