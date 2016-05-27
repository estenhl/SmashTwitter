import Foundation

public class MediaItem {
    public let url: NSURL
    public let aspectRatio: Double
    
    public init(url: NSURL, aspectRatio: Double) {
        self.url = url
        self.aspectRatio = aspectRatio
    }
}