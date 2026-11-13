import Observation

/// Reducer style: a minimal store. State changes only through `send`.
@Observable
public final class Store<State, Action, Environment> {
    public private(set) var state: State
    @ObservationIgnored private let environment: Environment
    @ObservationIgnored private let reducer: (inout State, Action, Environment) -> Void

    public init(
        initialState: State,
        environment: Environment,
        reducer: @escaping (inout State, Action, Environment) -> Void
    ) {
        state = initialState
        self.environment = environment
        self.reducer = reducer
    }

    public func send(_ action: Action) {
        reducer(&state, action, environment)
    }
}
