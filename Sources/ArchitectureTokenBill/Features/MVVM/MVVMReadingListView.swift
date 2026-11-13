#if canImport(SwiftUI)
import SwiftUI

/// MVVM: the view only renders the model and forwards taps.
public struct MVVMReadingListView: View {
    @State private var model: ReadingListViewModel

    public init(model: ReadingListViewModel = ReadingListViewModel(service: InMemoryReadingListService())) {
        _model = State(initialValue: model)
    }

    public var body: some View {
        List {
            Section("\(model.unreadCount) unread") {
                ForEach(model.articles) { article in
                    Button {
                        model.toggleRead(id: article.id)
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
