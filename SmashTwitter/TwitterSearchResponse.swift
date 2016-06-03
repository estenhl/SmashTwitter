import Foundation

public struct TwitterSearchResponse {
    let tweets: [Tweet]
    
    init(twitterSearchResponse: NSData) {
        var tweets = [Tweet]()
        do {
            let json = try NSJSONSerialization.JSONObjectWithData(twitterSearchResponse, options: .AllowFragments)
            
            if let statuses = json["statuses"] as? [[String: AnyObject]] {
                for status in statuses {
                    if let tweet = Tweet.tweetFromJson(status) {
                        tweets.append(tweet)
                    }
                }
            }
        } catch {
            print("error serializing JSON: \(error)")
        }
        self.tweets = tweets
    }
}