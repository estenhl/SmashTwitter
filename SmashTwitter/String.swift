import Foundation
import CommonCrypto

extension String {
    func toRFC1738() -> String {
        return self
    }
    
    func toBase64() -> String? {
        let utf8str = self.dataUsingEncoding(NSUTF8StringEncoding)
        
        return utf8str?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
    }
    
    func encodeWithHmacSha1(key: String) -> NSData {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = Int(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_SHA1_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        let keyStr = key.cStringUsingEncoding(NSUTF8StringEncoding)
        let keyLen = Int(key.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
            
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), keyStr!, keyLen, str!, strLen, result)
        return NSData(bytes: result, length: digestLen)
    }

    private func stringFromBytes(result: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String {
        let hash = NSMutableString()
        
        for i in 0..<length {
            hash.appendFormat("%02x", result[i])
        }
        return String(hash)
    }
}

extension String {
    private var validCharacters: String {
        return "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-._~"
    }
    
    func toRFC3986() -> String? {
        var percentEncodedString = ""
        for character in self.characters {
            if validCharacters.rangeOfString(String(character)) != nil {
                percentEncodedString.append(character)
            } else {
                let binaryValue = String(character).unicodeScalars.first!.value
                let binaryString = String(format:"%2X", binaryValue)
                percentEncodedString += "%\(binaryString)"
            }
        }
        return percentEncodedString
    }
}