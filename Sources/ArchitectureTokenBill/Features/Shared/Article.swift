/// The one model all three versions of the reading list share.
public struct Article: Identifiable, Equatable, Sendable {
    public let id: Int
    public var title: String
    public var isRead: Bool

    public init(id: Int, title: String, isRead: Bool = false) {
        self.id = id
        self.title = title
        self.isRead = isRead
    }

    public static let samples: [Article] = [
        Article(id: 1, title: "Swift 6 strict concurrency in practice"),
        Article(id: 2, title: "Observation vs Combine", isRead: true),
        Article(id: 3, title: "Shipping a widget in a weekend"),
        Article(id: 4, title: "What App Review rejected this week"),
    ]
}
