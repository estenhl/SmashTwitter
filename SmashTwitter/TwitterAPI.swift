import Twitter
import Foundation

public class TwitterAPI {
    public static let twitterURL = "https://api.twitter.com/1.1"
    public static let endpoints = [
    "search": "/search/tweets.json" // In extension
    ]
}

public extension TwitterAPI {
    public static func searchForTweets(searchString: String, withCount count: Int, andAdditionalParameters parameters: [String: String], fromMinId minId: String? = nil, handler: [Tweet] -> Void) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            if let endpoint = endpoints["search"] {
                let queryString = createQueryString(searchString, count: count, parameters: parameters, minId: minId)
                let path = twitterURL + endpoint + "?" + queryString
                let url = NSURL(string: path)
                
                if let url = url {
                    let request = NSMutableURLRequest(URL: url)
                    let OAuthHeader = generateOAuthHeader(searchString, count: count, parameters: parameters, url: path, httpMethod: "GET")
                    print("Path: \(path)")
                    print("OAuthHeader: \(OAuthHeader)")
                    request.setValue(OAuthHeader, forHTTPHeaderField: "Authorization")
                    request.HTTPMethod = "GET"
                    
                    executeRequest(request, handler: handleTwitterSearchResponse, tweetHandler: handler)
                }
            }
        }
    }
    
    private static func createQueryString(searchString: String, count: Int, parameters: [String: String], minId: String? = nil) -> String {
        var queryString = "q=" + searchString
        queryString += "&count=" + String(count)
        
        for (key, value) in parameters {
            queryString += "&" + key + "=" + value
        }
        
        if let minId = minId {
            queryString += "&since_id=" + minId
        }
        
        return queryString
    }
    
    private static func generateOAuthHeader(searchString: String, count: Int, parameters: [String: String], url: String, httpMethod: String, minId: String? = nil) -> String {
        var OAuthParameters = [String: String]()
        OAuthParameters["oauth_consumer_key"] = TwitterCredentials.readCredentialsFromFile(TwitterCredentials.TwitterOAuthCredentialFiles.ConsumerKey)
        OAuthParameters["oauth_nonce"] = OAuth.generateNonce(searchString)
        OAuthParameters["oauth_timestamp"] = OAuth.generateTimestamp()
        OAuthParameters["oauth_token"] = TwitterCredentials.readCredentialsFromFile(TwitterCredentials.TwitterOAuthCredentialFiles.AccessToken)
        OAuthParameters["oauth_version"] = OAuth.Versions["Twitter"]
        OAuthParameters["oauth_signature_method"] = OAuth.SignatureMethods["Twitter"]
        OAuthParameters["q"] = searchString
        OAuthParameters["count"] = String(count)
        if minId != nil {
            OAuthParameters["since_id"] = minId
        }
        for (key, value) in parameters {
            OAuthParameters[key] = value
        }
        let OAuthSignature = OAuth.generateSignature(parameters, url: url, httpMethod: httpMethod)
        
        return OAuth.createHeaderFromParameters(OAuthParameters, withSignature: OAuthSignature)
    }
    
    private static func executeRequest(request: NSMutableURLRequest, handler: (NSData?, NSURLResponse?, NSError?, [Tweet] -> Void) -> Void, tweetHandler: [Tweet] -> Void) {
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {data, response, error in handler(data, response, error, tweetHandler) }
        task.resume()
    }
    
    private static func handleTwitterSearchResponse(data: NSData?, response: NSURLResponse?, error: NSError?, handler: [Tweet] -> Void) {
        if let httpResponse = response as? NSHTTPURLResponse {
            if let data = data where httpResponse.statusCode == 200 {
                handler(parseTwitterSearchResponse(String(data: data, encoding: NSUTF8StringEncoding)))
            } else {
                print("Http response code: \(httpResponse.statusCode)")
                print("Response: \(httpResponse.debugDescription)")
            }
        }
    }
    
    private static func parseTwitterSearchResponse(response: String?) -> [Tweet] {
        if let response = response {
            print(response)
        }
        return [Tweet]()
    }
}