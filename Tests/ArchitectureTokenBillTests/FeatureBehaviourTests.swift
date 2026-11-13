import XCTest
@testable import ArchitectureTokenBill

/// The MVVM and reducer versions must behave the same, or the footprint
/// comparison is not comparing like with like.
final class FeatureBehaviourTests: XCTestCase {
    func testMVVMTogglesAndSaves() {
        let service = InMemoryReadingListService()
        let model = ReadingListViewModel(service: service)
        XCTAssertEqual(model.unreadCount, 3)
        model.toggleRead(id: 1)
        XCTAssertEqual(model.unreadCount, 2)
        XCTAssertEqual(service.load().first { $0.id == 1 }?.isRead, true)
    }

    func testMVVMUnknownIdIsIgnored() {
        let service = InMemoryReadingListService()
        let model = ReadingListViewModel(service: service)
        model.toggleRead(id: 999)
        XCTAssertEqual(model.articles, Article.samples)
    }

    func testReducerTogglesAndSaves() {
        var saved: [Article] = []
        let store = ReadingListFeature.makeStore(environment: .init(save: { saved = $0 }))
        XCTAssertEqual(store.state.unreadCount, 3)
        store.send(.toggleRead(id: 1))
        XCTAssertEqual(store.state.unreadCount, 2)
        XCTAssertEqual(saved.first { $0.id == 1 }?.isRead, true)
    }

    func testReducerUnknownIdIsIgnoredAndNotSaved() {
        var saveCount = 0
        var state = ReadingListFeature.State()
        ReadingListFeature.reduce(&state, .toggleRead(id: 999), .init(save: { _ in saveCount += 1 }))
        XCTAssertEqual(state.articles, Article.samples)
        XCTAssertEqual(saveCount, 0)
    }
}
