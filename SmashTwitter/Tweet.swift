import Foundation

// Struct
public class Tweet {
    public let text: String
    public let user: User
    public let created: NSDate
    public let id: String
    public let media: [MediaItem]?
    public let hashtags: [Mention]?
    public let urls: [Mention]?
    public let userMentions: [Mention]?
    
    // Lesbar
    init(text: String,
         user: User, created: NSDate, id: String, media: [MediaItem]? = nil, hashtags: [Mention]? = nil, urls: [Mention]? = nil, userMentions: [Mention]? = nil) {
        self.text = text
        self.user = user
        self.created = created
        self.id = id
        self.media = media
        self.hashtags = hashtags
        self.urls = urls
        self.userMentions = userMentions
    }
}

public extension Tweet {
    private static let numberOfGeneratedGenericItems = 3
    
    static func generateGenericTweet(id: Int) -> Tweet {
        var hashtags = [Mention]()
        var urls = [Mention]()
        var userMentions = [Mention]()
        for i in 0...numberOfGeneratedGenericItems {
            hashtags.append(Mention(text: "#hashtag\(i)"))
            urls.append(Mention(text: "http://www.url\(i).com"))
            userMentions.append(Mention(text: "User \(i)"))
        }
        
        let user = User(screenName: "User\(id)", name: "Generic user \(id)", id: String(id), verified: false)
        return Tweet(text: "Generic tweet \(id)", user: user, created: NSDate(), id: String(id), hashtags: hashtags, urls: urls, userMentions: userMentions)
    }
}