import Foundation

public class OAuth {
    public static let Versions = [
    "Twitter": "1.0"
    ]
    
    public static let SignatureMethods = [
    "Twitter": "HMAC-SHA1"
    ]
    
    static func createParameterString(parameters: [String: String], url: String, httpMethod: String) {
        
    }
    
    static func generateNonce(key: String) -> String {
        if let value = key.toBase64() {
            return value
        }
        return key
    }
    
    static func generateTimestamp() -> String {
        let date = NSDate()
        
        return String(date.timeIntervalSince1970)
    }
}