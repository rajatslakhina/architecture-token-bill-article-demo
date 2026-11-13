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

    public var body: some View {
        List {
            Section("\(unreadCount) unread") {
                ForEach($articles) { $article in
                    Toggle(article.title, isOn: $article.isRead)
                }
            }
        }
        .onChange(of: articles) { _, newValue in save(newValue) }
    }
}
#endif
