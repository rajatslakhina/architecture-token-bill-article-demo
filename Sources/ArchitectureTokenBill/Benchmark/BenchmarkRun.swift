/// One agent run of one feature in one architecture.
///
/// Claude Code reports cost and tokens at the end of a session; wall-clock
/// minutes and the conformance result come from your own harness.
public struct BenchmarkRun: Equatable, Sendable {
    public let architecture: String
    public let costUSD: Double
    public let tokens: Int
    public let minutes: Double
    public let passedConformance: Bool

    public init(architecture: String, costUSD: Double, tokens: Int, minutes: Double, passedConformance: Bool) {
        self.architecture = architecture
        self.costUSD = costUSD
        self.tokens = tokens
        self.minutes = minutes
        self.passedConformance = passedConformance
    }
}

public struct ArchitectureSummary: Equatable, Sendable {
    public let architecture: String
    public let runCount: Int
    public let passCount: Int
    public let cost: Spread
    public let tokens: Spread
    public let minutes: Spread
    public let totalCostUSD: Double

    /// Every dollar spent, failed runs included, divided by the runs that
    /// produced a working feature. Nil when nothing passed.
    public var costPerPassingRun: Double? {
        guard passCount > 0 else { return nil }
        return totalCostUSD / Double(passCount)
    }

    /// Summaries per architecture, cheapest median cost first.
    public static func summarize(_ runs: [BenchmarkRun]) -> [ArchitectureSummary] {
        let grouped = Dictionary(grouping: runs, by: \.architecture)
        let summaries: [ArchitectureSummary] = grouped.compactMap { name, group in
            guard let cost = Stats.spread(group.map(\.costUSD)),
                  let tokens = Stats.spread(group.map { Double($0.tokens) }),
                  let minutes = Stats.spread(group.map(\.minutes)) else { return nil }
            return ArchitectureSummary(
                architecture: name,
                runCount: group.count,
                passCount: group.filter(\.passedConformance).count,
                cost: cost,
                tokens: tokens,
                minutes: minutes,
                totalCostUSD: group.map(\.costUSD).reduce(0, +)
            )
        }
        return summaries.sorted {
            $0.cost.median == $1.cost.median ? $0.architecture < $1.architecture : $0.cost.median < $1.cost.median
        }
    }
}
