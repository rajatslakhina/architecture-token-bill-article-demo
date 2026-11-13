import Observation

/// MVVM: the rules move out of the view into a testable model.
@Observable
public final class ReadingListViewModel {
    public private(set) var articles: [Article]
    @ObservationIgnored private let service: ReadingListService

    public init(service: ReadingListService) {
        self.service = service
        articles = service.load()
    }

    public var unreadCount: Int { articles.filter { !$0.isRead }.count }

    public func toggleRead(id: Int) {
        guard let index = articles.firstIndex(where: { $0.id == id }) else { return }
        articles[index].isRead.toggle()
        service.save(articles)
    }
}
