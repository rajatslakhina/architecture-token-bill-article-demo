/// Reducer style: state, actions, dependencies and rules declared up front.
public enum ReadingListFeature {
    public struct State: Equatable {
        public var articles: [Article]

        public init(articles: [Article] = Article.samples) {
            self.articles = articles
        }

        public var unreadCount: Int { articles.filter { !$0.isRead }.count }
    }

    public enum Action: Equatable {
        case toggleRead(id: Int)
    }

    public struct Environment {
        public var save: ([Article]) -> Void

        public init(save: @escaping ([Article]) -> Void = { _ in }) {
            self.save = save
        }
    }

    public static func reduce(_ state: inout State, _ action: Action, _ environment: Environment) {
        switch action {
        case .toggleRead(let id):
            guard let index = state.articles.firstIndex(where: { $0.id == id }) else { return }
            state.articles[index].isRead.toggle()
            environment.save(state.articles)
        }
    }

    public static func makeStore(
        state: State = State(),
        environment: Environment = Environment()
    ) -> Store<State, Action, Environment> {
        Store(initialState: state, environment: environment, reducer: reduce)
    }
}
