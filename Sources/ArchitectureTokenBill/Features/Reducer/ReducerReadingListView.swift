#if canImport(SwiftUI)
import SwiftUI

/// Reducer style: the view reads state and sends actions.
public struct ReducerReadingListView: View {
    @State private var store: Store<ReadingListFeature.State, ReadingListFeature.Action, ReadingListFeature.Environment>

    public init(store: Store<ReadingListFeature.State, ReadingListFeature.Action, ReadingListFeature.Environment> = ReadingListFeature.makeStore()) {
        _store = State(initialValue: store)
    }

    public var body: some View {
        List {
            Section("\(store.state.unreadCount) unread") {
                ForEach(store.state.articles) { article in
                    Button {
                        store.send(.toggleRead(id: article.id))
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
