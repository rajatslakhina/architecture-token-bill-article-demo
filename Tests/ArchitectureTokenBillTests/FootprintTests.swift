import XCTest
@testable import ArchitectureTokenBill

final class FootprintTests: XCTestCase {
    private var packageRoot: URL {
        URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
    }

    /// The numbers the demo app shows must match the real files.
    func testMeasuredFilesMatchSource() throws {
        for recorded in MeasuredFiles.all {
            let url = packageRoot.appendingPathComponent(recorded.path)
            let text = try String(contentsOf: url, encoding: .utf8)
            let measured = FileFootprint.measure(path: recorded.path, text: text)
            XCTAssertEqual(measured, recorded, "Re-measure \(recorded.path): \(measured.nonBlankLines) lines, \(measured.characters) chars")
        }
    }

    func testEveryChangePathIsMeasured() {
        for (_, entry) in UnreadFilterChange.paths {
            for path in entry.edited + entry.readOnly {
                XCTAssertTrue(MeasuredFiles.all.contains { $0.path == path }, "\(path) is not in MeasuredFiles")
            }
        }
        XCTAssertEqual(UnreadFilterChange.footprints.count, Architecture.allCases.count)
    }

    func testPlainIsSmallestAndReducerLargest() throws {
        let byArch = Dictionary(uniqueKeysWithValues: UnreadFilterChange.footprints.map { ($0.architecture, $0) })
        let plain = try XCTUnwrap(byArch[.plainSwiftUI])
        let mvvm = try XCTUnwrap(byArch[.mvvm])
        let reducer = try XCTUnwrap(byArch[.reducer])
        XCTAssertEqual(plain.fileCount, 2)
        XCTAssertEqual(mvvm.fileCount, 4)
        XCTAssertEqual(reducer.fileCount, 4)
        XCTAssertLessThan(plain.estimatedTokens, mvvm.estimatedTokens)
        XCTAssertLessThan(mvvm.estimatedTokens, reducer.estimatedTokens)
    }

    func testMeasureCountsNonBlankLines() {
        let f = FileFootprint.measure(path: "x", text: "a\n\n  \nb\n")
        XCTAssertEqual(f.nonBlankLines, 2)
        XCTAssertEqual(f.characters, 8)
        XCTAssertEqual(FileFootprint.measure(path: "e", text: "").nonBlankLines, 0)
    }

    func testTokenEstimateRoundsUpAndGuards() {
        XCTAssertEqual(TokenEstimate.tokens(characters: 9), 3)
        XCTAssertEqual(TokenEstimate.tokens(characters: 8), 2)
        XCTAssertEqual(TokenEstimate.tokens(characters: 0), 0)
        XCTAssertEqual(TokenEstimate.tokens(characters: 100, charactersPerToken: 0), 0)
    }
}
