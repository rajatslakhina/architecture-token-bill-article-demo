public enum Architecture: String, CaseIterable, Sendable, Identifiable {
    case plainSwiftUI = "Plain SwiftUI"
    case mvvm = "MVVM"
    case reducer = "Reducer"
    public var id: String { rawValue }
}

/// The files an agent has to load to make one change in one architecture.
public struct ChangeFootprint: Equatable, Sendable, Identifiable {
    public let architecture: Architecture
    public let edited: [FileFootprint]
    public let readOnly: [FileFootprint]
    public var id: Architecture { architecture }

    public var files: [FileFootprint] { edited + readOnly }
    public var fileCount: Int { files.count }
    public var nonBlankLines: Int { files.map(\.nonBlankLines).reduce(0, +) }
    public var characters: Int { files.map(\.characters).reduce(0, +) }
    public var estimatedTokens: Int { TokenEstimate.tokens(characters: characters) }
}

/// The change: "add an Unread only filter to the reading list".
///
/// In each architecture the agent must open every file it edits plus every
/// file whose types it has to understand to edit them correctly. This is the
/// context loaded once, a lower bound: real sessions re-read files, run
/// builds and read test output on top of it.
public enum UnreadFilterChange {
    static let root = "Sources/ArchitectureTokenBill/Features/"

    public static let paths: [Architecture: (edited: [String], readOnly: [String])] = [
        .plainSwiftUI: (
            edited: [root + "Plain/PlainReadingListView.swift"],
            readOnly: [root + "Shared/Article.swift"]
        ),
        .mvvm: (
            edited: [root + "MVVM/ReadingListViewModel.swift", root + "MVVM/MVVMReadingListView.swift"],
            readOnly: [root + "MVVM/ReadingListService.swift", root + "Shared/Article.swift"]
        ),
        .reducer: (
            edited: [root + "Reducer/ReadingListFeature.swift", root + "Reducer/ReducerReadingListView.swift"],
            readOnly: [root + "Reducer/Store.swift", root + "Shared/Article.swift"]
        ),
    ]

    /// Footprints built from `MeasuredFiles`, which a test re-measures
    /// against the real source files so the numbers cannot drift.
    public static var footprints: [ChangeFootprint] {
        Architecture.allCases.compactMap { architecture in
            guard let entry = paths[architecture] else { return nil }
            let lookup: (String) -> FileFootprint? = { path in MeasuredFiles.all.first { $0.path == path } }
            return ChangeFootprint(
                architecture: architecture,
                edited: entry.edited.compactMap(lookup),
                readOnly: entry.readOnly.compactMap(lookup)
            )
        }
    }
}
