import Twitter
import Foundation

public enum TwitterAPIStatus {
    case Initialized
    case Awaiting
    case Ready
    case Failed
}

public class TwitterAPI {
    public let twitterURL = "https://api.twitter.com/1.1"
    public let endpoints = [
    "oauth": "oauth2/token?grant_type=client_credentials",
    "search": "1.1/search/tweets.json"
    ]
    
    public var status = TwitterAPIStatus.Initialized
    public var errorMessage: String?
    private var bearerToken: String?
}

public extension TwitterAPI {
    convenience init(credentialType: TwitterCredentials.CredentialType) {
        self.init()
        if let credentials = TwitterCredentials.getTwitterConsumerCredentialString(credentialType) {
            setOAuthBearerToken(credentials)
        } else {
            status = .Failed
            errorMessage = "Invalid credentials"
        }
    }
    
    private func setOAuthBearerToken(credentials: String) {
        if let endpoint = endpoints["oauth"] {
            let path = twitterURL + endpoint
            let url = NSURL(string: path)
            if let url = url {
                let request = NSMutableURLRequest(URL: url)
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.setValue("Basic \(credentials)", forHTTPHeaderField: "Authorization")
                request.HTTPMethod = "POST"
        
                let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                    [weak self] data, response, error in
                    
                    if let strongSelf = self {
                        if let httpResponse = response as? NSHTTPURLResponse {
                            if let data = data where httpResponse.statusCode == 200 {
                                strongSelf.status = .Ready
                                strongSelf.bearerToken = String(data: data, encoding: NSUTF8StringEncoding)
                            } else {
                                strongSelf.status = .Failed
                                weakSelf?.errorMessage = "Request for credentials returned http response code \(httpResponse.statusCode)"
                            }
                        }
                        if let error = error {
                            weakSelf?.status = .Failed
                            weakSelf?.errorMessage = "Request for credentials returned error code \(error.code)"
                        }
                    }
            
                    
                }
                task.resume()
                status = .Awaiting
            } else {
                status = .Failed
                errorMessage = "Invalid Twitter API url"
            }
        }
    }
}

public extension TwitterAPI {
    public func searchForTweets(searchString: String, withCount count: Int, andAdditionalParameters parameters: [String: String], fromMaxId maxId: String? = nil, handler: [Tweet] -> Void) {
        if self.status != .Ready {
            return
        }
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            [weak weakSelf = self] in
            
            if let weakSelf = weakSelf,
               let endpoint = weakSelf.endpoints["search"] {
                let path = weakSelf.twitterURL + endpoint
                let url = NSURL(string: path)
                if let url = url {
                    // create auth string
                    let request = NSMutableURLRequest(URL: url)
                    request.HTTPMethod = "GET"
                    // set auth string
                    // parse response
                    // handler(tweets)
                }
            }
        }
    }
    
    private func generateOAuthHeader(searchString: String, count: Int, parameters: [String: String], url: String, httpMethod: String) {
        var OAuthParameters = [String: String]()
        OAuthParameters["oauth_consumer_key"] = TwitterCredentials.readFile(TwitterCredentials.TwitterOAuthCredentialFiles.ConsumerKey)
        OAuthParameters["oauth_nonce"] = OAuth.generateNonce(searchString)
        OAuthParameters["oauth_timestamp"] = OAuth.generateTimestamp()
        OAuthParameters["oauth_token"] = TwitterCredentials.readFile(TwitterCredentials.TwitterOAuthCredentialFiles.AccessToken)
        OAuthParameters["oauth_version"] = OAuth.Versions["Twitter"]
        OAuthParameters["oauth_signature_method"] = OAuth.SignatureMethods["Twitter"]
        var OAuthSignature =
    }
}