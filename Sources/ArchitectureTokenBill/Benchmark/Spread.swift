/// A median with the lowest and highest observed value.
public struct Spread: Equatable, Sendable {
    public let median: Double
    public let min: Double
    public let max: Double

    public init(median: Double, min: Double, max: Double) {
        self.median = median
        self.min = min
        self.max = max
    }

    /// True when the two min–max ranges share any value (touching counts).
    ///
    /// This is a deliberately crude, conservative check, not a significance
    /// test: if even the observed ranges overlap, the medians alone should not
    /// decide an architecture.
    public func overlaps(_ other: Spread) -> Bool {
        !(max < other.min || other.max < min)
    }
}

public enum Stats {
    /// Median of the values, or nil when there are none.
    public static func median(_ values: [Double]) -> Double? {
        guard !values.isEmpty else { return nil }
        let sorted = values.sorted()
        let middle = sorted.count / 2
        if sorted.count.isMultiple(of: 2) {
            return (sorted[middle - 1] + sorted[middle]) / 2
        }
        return sorted[middle]
    }

    /// Median, min and max of the values, or nil when there are none.
    public static func spread(_ values: [Double]) -> Spread? {
        guard let median = median(values),
              let low = values.min(),
              let high = values.max() else { return nil }
        return Spread(median: median, min: low, max: high)
    }
}
