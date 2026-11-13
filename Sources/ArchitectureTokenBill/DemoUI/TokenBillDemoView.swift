#if canImport(SwiftUI)
import SwiftUI

/// Root view of the demo app: the measured footprint of one change in three
/// architectures, and Lawson's published cost ranges with a separability check.
public struct TokenBillDemoView: View {
    public enum Tab: String { case footprint, benchmark }

    @State private var tab: Tab
    @State private var selected: String?

    public init(tab: Tab = .footprint, selected: String? = nil) {
        _tab = State(initialValue: tab)
        _selected = State(initialValue: selected)
    }

    public var body: some View {
        TabView(selection: $tab) {
            NavigationStack { FootprintScreen() }
                .tabItem { Label("Footprint", systemImage: "doc.text.magnifyingglass") }
                .tag(Tab.footprint)
            NavigationStack { BenchmarkScreen(selected: $selected) }
                .tabItem { Label("Cost ranges", systemImage: "chart.bar.xaxis") }
                .tag(Tab.benchmark)
        }
    }
}

struct FootprintScreen: View {
    private let footprints = UnreadFilterChange.footprints
    private var largest: Int { footprints.map(\.estimatedTokens).max() ?? 1 }

    var body: some View {
        List {
            Section {
                Text("Change: add an “Unread only” filter. Same feature, same behaviour, three architectures. Counted from the real source files in this package.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            Section("Context loaded for this change") {
                ForEach(footprints) { footprint in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(footprint.architecture.rawValue).font(.headline)
                            Spacer()
                            Text("≈\(footprint.estimatedTokens) tokens").font(.headline.monospacedDigit())
                        }
                        GeometryReader { proxy in
                            Capsule()
                                .fill(.tint)
                                .frame(width: max(8, proxy.size.width * Double(footprint.estimatedTokens) / Double(max(largest, 1))))
                        }
                        .frame(height: 8)
                        Text("\(footprint.fileCount) files · \(footprint.nonBlankLines) lines · \(footprint.edited.count) edited")
                            .font(.caption.monospacedDigit())
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 2)
                    .accessibilityElement(children: .combine)
                }
            }
            ForEach(footprints) { footprint in
                Section("\(footprint.architecture.rawValue) files") {
                    ForEach(footprint.edited) { file in
                        FileRow(file: file, edited: true)
                    }
                    ForEach(footprint.readOnly) { file in
                        FileRow(file: file, edited: false)
                    }
                }
            }
            Section {
                Text("Tokens ≈ characters ÷ 4, a rule of thumb, not a tokenizer. This is context loaded once; real agent sessions re-read files and build output on top.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Token bill of one change")
    }
}

struct FileRow: View {
    let file: FileFootprint
    let edited: Bool

    var body: some View {
        HStack {
            Image(systemName: edited ? "pencil" : "eye")
                .foregroundStyle(edited ? Color.orange : Color.secondary)
            Text(file.path.split(separator: "/").last.map(String.init) ?? file.path)
                .font(.caption.monospaced())
            Spacer()
            Text("\(file.nonBlankLines) ln").font(.caption.monospacedDigit()).foregroundStyle(.secondary)
        }
    }
}

struct BenchmarkScreen: View {
    @Binding var selected: String?
    private let items = LawsonBenchmark.cost
    private var pairs: [SeparablePair] { RangeComparison.separablePairs(items) }
    private var upper: Double { (items.map(\.spread.max).max() ?? 1) * 1.05 }

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(pairs.count) of \(RangeComparison.pairCount(items.count)) pairs separable")
                        .font(.title3.bold())
                    Text("Cost per run, median of 5 with lowest–highest run (Nolan Lawson, 28 Oct 2026). A pair counts only if the two ranges don’t overlap at all. Tap a framework.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    if let selected {
                        let others = RangeComparison.separable(from: selected, in: items)
                        Text(others.isEmpty
                             ? "\(selected) overlaps every other framework: its median rank is not evidence on its own."
                             : "\(selected) is separable from: \(others.joined(separator: ", ")). It overlaps the other \(items.count - 1 - others.count).")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(others.isEmpty ? Color.secondary : Color.green)
                            .padding(.top, 4)
                    }
                }
            }
            Section {
                ForEach(items) { item in
                    Button {
                        selected = (selected == item.name) ? nil : item.name
                    } label: {
                        RangeRow(item: item, upper: upper, state: state(for: item.name))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .navigationTitle("Lawson’s cost ranges")
    }

    private func state(for name: String) -> RangeRow.State {
        guard let selected else { return .neutral }
        if name == selected { return .selected }
        return RangeComparison.separable(from: selected, in: items).contains(name) ? .separable : .overlapping
    }
}

struct RangeRow: View {
    enum State { case neutral, selected, separable, overlapping }
    let item: NamedSpread
    let upper: Double
    let state: State

    private var color: Color {
        switch state {
        case .neutral: return .accentColor
        case .selected: return .orange
        case .separable: return .green
        case .overlapping: return .gray.opacity(0.5)
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(item.name).font(.subheadline.weight(state == .selected ? .bold : .regular))
                Spacer()
                Text(String(format: "$%.2f  (%.2f–%.2f)", item.spread.median, item.spread.min, item.spread.max))
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            GeometryReader { proxy in
                let width = proxy.size.width
                let x0 = width * item.spread.min / upper
                let x1 = width * item.spread.max / upper
                let xm = width * item.spread.median / upper
                ZStack(alignment: .leading) {
                    Capsule().fill(color.opacity(0.35))
                        .frame(width: max(4, x1 - x0), height: 8)
                        .offset(x: x0)
                    Circle().fill(color).frame(width: 10, height: 10).offset(x: xm - 5)
                }
            }
            .frame(height: 10)
        }
        .padding(.vertical, 2)
        .accessibilityElement(children: .combine)
    }
}
#endif
