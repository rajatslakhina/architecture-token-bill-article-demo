import XCTest
@testable import ArchitectureTokenBill

final class BenchmarkTests: XCTestCase {
    private func run(_ arch: String, _ cost: Double, passed: Bool = true) -> BenchmarkRun {
        BenchmarkRun(architecture: arch, costUSD: cost, tokens: Int(cost * 1_000_000), minutes: cost * 3, passedConformance: passed)
    }

    func testSummariesSortedByMedianCost() {
        let runs = [run("Reducer", 5), run("MVVM", 3), run("Reducer", 4), run("MVVM", 2), run("Plain", 1)]
        let names = ArchitectureSummary.summarize(runs).map(\.architecture)
        XCTAssertEqual(names, ["Plain", "MVVM", "Reducer"])
    }

    func testCostPerPassingRunChargesFailedRuns() throws {
        let runs = [run("Angular", 5), run("Angular", 5), run("Angular", 5, passed: false), run("Angular", 5, passed: false), run("Angular", 5)]
        let summary = try XCTUnwrap(ArchitectureSummary.summarize(runs).first)
        XCTAssertEqual(summary.runCount, 5)
        XCTAssertEqual(summary.passCount, 3)
        XCTAssertEqual(summary.cost.median, 5)
        XCTAssertEqual(try XCTUnwrap(summary.costPerPassingRun), 25.0 / 3.0, accuracy: 1e-9)
    }

    func testNoPassingRunsHasNoCostPerPass() throws {
        let summary = try XCTUnwrap(ArchitectureSummary.summarize([run("X", 2, passed: false)]).first)
        XCTAssertNil(summary.costPerPassingRun)
    }

    func testEmptyInput() {
        XCTAssertTrue(ArchitectureSummary.summarize([]).isEmpty)
    }

    func testLawsonCostDataHasSixSeparablePairsOutOf66() {
        let items = LawsonBenchmark.cost
        XCTAssertEqual(items.count, 12)
        XCTAssertEqual(RangeComparison.pairCount(items.count), 66)
        let pairs = RangeComparison.separablePairs(items)
        XCTAssertEqual(pairs.count, 6)
        XCTAssertTrue(pairs.contains(SeparablePair(cheaper: "Hono+htmx", pricier: "SvelteKit")))
        XCTAssertTrue(pairs.contains(SeparablePair(cheaper: "Qwik", pricier: "Gracile+Lit")))
    }

    func testAngularOverlapsEveryone() {
        XCTAssertEqual(RangeComparison.separable(from: "Angular", in: LawsonBenchmark.cost), [])
        XCTAssertEqual(RangeComparison.separable(from: "React Router", in: LawsonBenchmark.cost), [])
        XCTAssertEqual(Set(RangeComparison.separable(from: "Gracile+Lit", in: LawsonBenchmark.cost)),
                       ["Hono+htmx", "Astro", "Vanilla", "Qwik"])
    }

    func testPairCountEdgeCases() {
        XCTAssertEqual(RangeComparison.pairCount(0), 0)
        XCTAssertEqual(RangeComparison.pairCount(1), 0)
        XCTAssertEqual(RangeComparison.pairCount(2), 1)
    }
}
