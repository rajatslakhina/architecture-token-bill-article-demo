import XCTest
@testable import ArchitectureTokenBill

final class StatsTests: XCTestCase {
    func testMedianOddEvenAndEmpty() {
        XCTAssertEqual(Stats.median([3, 1, 2]), 2)
        XCTAssertEqual(Stats.median([4, 1, 3, 2]), 2.5)
        XCTAssertNil(Stats.median([]))
    }

    func testSpread() {
        XCTAssertEqual(Stats.spread([2.5, 1, 4]), Spread(median: 2.5, min: 1, max: 4))
        XCTAssertNil(Stats.spread([]))
    }

    func testTouchingRangesOverlap() {
        let a = Spread(median: 2.67, min: 2.23, max: 3.19)
        let b = Spread(median: 4.97, min: 3.19, max: 6.82)
        XCTAssertTrue(a.overlaps(b), "Hono+htmx's max equals Angular's min: touching counts as overlap")
        XCTAssertTrue(b.overlaps(a))
    }

    func testDisjointRanges() {
        let a = Spread(median: 1, min: 0.5, max: 1.5)
        let b = Spread(median: 3, min: 2, max: 4)
        XCTAssertFalse(a.overlaps(b))
        XCTAssertFalse(b.overlaps(a))
    }
}
