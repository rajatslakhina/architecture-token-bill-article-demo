/// MVVM: persistence sits behind a protocol so the view model can be tested.
public protocol ReadingListService: AnyObject {
    func load() -> [Article]
    func save(_ articles: [Article])
}

public final class InMemoryReadingListService: ReadingListService {
    private var stored: [Article]

    public init(seed: [Article] = Article.samples) {
        stored = seed
    }

    public func load() -> [Article] { stored }

    public func save(_ articles: [Article]) { stored = articles }
}
