public struct NamedSpread: Equatable, Sendable, Identifiable {
    public let name: String
    public let spread: Spread
    public var id: String { name }

    public init(name: String, spread: Spread) {
        self.name = name
        self.spread = spread
    }
}

public struct SeparablePair: Equatable, Sendable {
    public let cheaper: String
    public let pricier: String
}

public enum RangeComparison {
    /// Number of unordered pairs among `count` items.
    public static func pairCount(_ count: Int) -> Int {
        count < 2 ? 0 : count * (count - 1) / 2
    }

    /// Pairs whose min–max ranges do not overlap at all.
    public static func separablePairs(_ items: [NamedSpread]) -> [SeparablePair] {
        var pairs: [SeparablePair] = []
        for i in items.indices {
            for j in items.indices where j > i {
                let a = items[i], b = items[j]
                guard !a.spread.overlaps(b.spread) else { continue }
                pairs.append(a.spread.max < b.spread.min
                    ? SeparablePair(cheaper: a.name, pricier: b.name)
                    : SeparablePair(cheaper: b.name, pricier: a.name))
            }
        }
        return pairs
    }

    /// Names whose range does not overlap `name`'s range.
    public static func separable(from name: String, in items: [NamedSpread]) -> [String] {
        separablePairs(items).compactMap { pair in
            if pair.cheaper == name { return pair.pricier }
            if pair.pricier == name { return pair.cheaper }
            return nil
        }
    }
}
