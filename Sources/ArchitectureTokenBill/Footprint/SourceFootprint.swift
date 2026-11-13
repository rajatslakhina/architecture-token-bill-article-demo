/// Size of one source file as an agent would load it.
public struct FileFootprint: Equatable, Sendable, Identifiable {
    public let path: String
    public let nonBlankLines: Int
    public let characters: Int
    public var id: String { path }

    public init(path: String, nonBlankLines: Int, characters: Int) {
        self.path = path
        self.nonBlankLines = nonBlankLines
        self.characters = characters
    }

    /// Measures file text the same way Lawson counted lines: non-blank lines.
    public static func measure(path: String, text: String) -> FileFootprint {
        let lines = text.split(separator: "\n", omittingEmptySubsequences: false)
            .filter { !$0.allSatisfy(\.isWhitespace) }
        return FileFootprint(path: path, nonBlankLines: lines.count, characters: text.count)
    }
}

public enum TokenEstimate {
    /// Rough token count from characters. Four characters per token is a
    /// common rule of thumb for English and code, not a real tokenizer:
    /// use Claude's token-counting endpoint when the exact number matters.
    public static func tokens(characters: Int, charactersPerToken: Double = 4) -> Int {
        guard characters > 0, charactersPerToken > 0 else { return 0 }
        return Int((Double(characters) / charactersPerToken).rounded(.up))
    }
}
