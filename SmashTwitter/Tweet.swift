import Foundation

public struct Tweet {
    public let text: String
    public let user: User
    public let created: NSDate
    public let id: String
    public let media: [MediaItem]?
    public let hashtags: [Mention]?
    public let urls: [Mention]?
    public let userMentions: [Mention]?
    
    init(text: String,
         user: User,
         created: NSDate,
         id: String,
         media: [MediaItem]? = nil,
         hashtags: [Mention]? = nil,
         urls: [Mention]? = nil,
         userMentions: [Mention]? = nil) {
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
    private struct JsonFields {
        static let Text = "text"
        static let User = "user"
        static let Created = "created_at"
        static let Id = "id_str"
        static let MediaUrl = "media_url_https"
        static let Entities = "entities"
        static let Indices = "indices"
        static let Url = "url"
        static let HashtagText = "text"
        
        struct UserFields {
            static let ScreenName = "screen_name"
            static let Name = "name"
            static let Id = "id_str"
            static let ProfileImageUrl = "profile_image_url_https"
        }
        
        struct EntityFields {
            static let HashTags = "hashtags"
            static let UserMentions = "user_mentions"
            static let Urls = "urls"
            static let Media = "media"
        }
    }
    
    public static func tweetFromJson(obj: [String: AnyObject]) -> Tweet? {
        guard let text = obj[JsonFields.Text] as? String,
            let created = obj[JsonFields.Created] as? String,
            let id = obj[JsonFields.Id] as? String,
            let userObj = obj[JsonFields.User] as? [String: AnyObject],
            let screenName = userObj[JsonFields.UserFields.ScreenName] as? String,
            let name = userObj[JsonFields.UserFields.Name] as? String,
            let userId = userObj[JsonFields.UserFields.Id] as? String
        else {
            print("Invalid tweet")
            return nil
        }
        var profileImageUrl: NSURL? = nil
        if let url = NSURL(string: (userObj[JsonFields.UserFields.ProfileImageUrl] as? String)!) {
            profileImageUrl = url
        }
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM dd HH:mm:ss         XXXXX yyyy"
        guard let date = formatter.dateFromString(created)
        else {
                print("Invalid date format")
                return nil
        }

        
        var items = [MediaItem]()
        var hashtags: [Mention]?
        var userMentions: [Mention]?
        var urls: [Mention]?
        if let entities = obj[JsonFields.Entities] as? [String: AnyObject] {
            if let mediaItems = entities[JsonFields.EntityFields.Media] as? [[String: AnyObject]] {
                for media in mediaItems {
                    if let mediaUrl = media[JsonFields.MediaUrl] as? String,
                       let url = NSURL(string: mediaUrl) {
                        items.append(MediaItem(url: url, aspectRatio: 1.0))
                    }
                }
            }
            
            userMentions = extractMentions(entities[JsonFields.EntityFields.UserMentions] as? [[String: AnyObject]],
                                           withTargetField: JsonFields.UserFields.ScreenName,
                                           returningClass: UserMention.self)
            
            urls = extractMentions(entities[JsonFields.EntityFields.Urls] as? [[String: AnyObject]],
                                   withTargetField: JsonFields.Url,
                                   returningClass: Url.self)
            
            hashtags = extractMentions(entities[JsonFields.EntityFields.HashTags] as? [[String: AnyObject]],
                                       withTargetField: JsonFields.HashtagText,
                                       returningClass: Hashtag.self)
        }
        
        let user = User(screenName: screenName,
                        name: name,
                        id: userId,
                        verified: false,
                        profileImageURL: profileImageUrl)
        
        return Tweet(text: text,
                     user: user,
                     created: date,
                     id: id,
                     media: items,
                     hashtags: hashtags,
                     urls: urls,
                     userMentions: userMentions)
    }
    
    private static func extractMentions<T: Mention>(entities: [[String: AnyObject]]?, withTargetField target: String, returningClass class: T.Type) -> [Mention]? {
        var mentions = [Mention]()
        if let entities = entities {
            for entity in entities {
                if let value = entity[target] as? String,
                   let indices = entity[JsonFields.Indices] as? [Int]
                   where indices.count == 2 {
                    mentions.append(T(text: value, range: indices[0]...indices[1]))
                }
            }
            return mentions
        }
        
        return nil
    }
}