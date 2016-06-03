import Foundation

public class Mention {
    public let text: String
    public let color: UIColor
    public let range: Range<Int>
    
    required public init(text: String, range: Range<Int>) {
        self.text = text
        self.range = range
        self.color = UIColor.blackColor()
    }
    
    public init(text: String, range: Range<Int>, color: UIColor) {
        self.text = text
        self.range = range
        self.color = color
    }
}

public class Hashtag: Mention {
    public required init(text: String, range: Range<Int>) {
        super.init(text: text, range: range, color: UIColor.blueColor())
    }
}

public class Url: Mention {
    public required init(text: String, range: Range<Int>) {
        super.init(text: text, range: range, color: UIColor.redColor())
    }
}

public class UserMention: Mention {
    public required init(text: String, range: Range<Int>) {
        super.init(text: text, range: range, color: UIColor.greenColor())
    }
}