import Foundation

extension String {
    func toRFC1738() -> String {
        return self
    }
    
    func toRFC3986() -> String? {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
    }
    
    func toBase64() -> String? {
        let utf8str = self.dataUsingEncoding(NSUTF8StringEncoding)
        
        return utf8str?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
    }
    
    func encodeWithHmacSha1(key: String) -> String {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = Int(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = 
    }
}