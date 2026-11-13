#if canImport(SwiftUI)
import SwiftUI

/// Plain SwiftUI: state, rules and persistence live in the view.
public struct PlainReadingListView: View {
    @State private var articles: [Article]
    private let save: ([Article]) -> Void

    public init(articles: [Article] = Article.samples, save: @escaping ([Article]) -> Void = { _ in }) {
        _articles = State(initialValue: articles)
        self.save = save
    }

    private var unreadCount: Int { articles.filter { !$0.isRead }.count }

    private func toggleRead(id: Int) {
        guard let index = articles.firstIndex(where: { $0.id == id }) else { return }
        articles[index].isRead.toggle()
        save(articles)
    }

    public var body: some View {
        List {
            Section("\(unreadCount) unread") {
                ForEach(articles) { article in
                    Button {
                        toggleRead(id: article.id)
                    } label: {
                        HStack {
                            Text(article.title)
                            Spacer()
                            Image(systemName: article.isRead ? "checkmark.circle.fill" : "circle")
                        }
                    }
                }
            }
        }
    }
}
#endif
