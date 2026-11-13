/// Published per-run API cost (USD) from Nolan Lawson, "The AI cost of
/// JavaScript frameworks" (28 Oct 2026): median of 5 runs with the lowest
/// and highest run, as printed in the post's cost table.
/// https://nolanlawson.com/2026/10/28/the-ai-cost-of-javascript-frameworks/
public enum LawsonBenchmark {
    public static let sourceURL = "https://nolanlawson.com/2026/10/28/the-ai-cost-of-javascript-frameworks/"

    public static let cost: [NamedSpread] = [
        NamedSpread(name: "Hono+htmx", spread: Spread(median: 2.67, min: 2.23, max: 3.19)),
        NamedSpread(name: "Astro", spread: Spread(median: 2.76, min: 2.16, max: 3.63)),
        NamedSpread(name: "Nuxt", spread: Spread(median: 2.82, min: 2.39, max: 4.25)),
        NamedSpread(name: "Vanilla", spread: Spread(median: 2.98, min: 2.24, max: 3.37)),
        NamedSpread(name: "Next.js", spread: Spread(median: 3.14, min: 2.58, max: 4.13)),
        NamedSpread(name: "Qwik", spread: Spread(median: 3.27, min: 2.35, max: 3.80)),
        NamedSpread(name: "TanStack Start", spread: Spread(median: 3.54, min: 3.11, max: 3.96)),
        NamedSpread(name: "SolidStart", spread: Spread(median: 3.79, min: 2.84, max: 4.81)),
        NamedSpread(name: "React Router", spread: Spread(median: 3.81, min: 2.82, max: 3.97)),
        NamedSpread(name: "SvelteKit", spread: Spread(median: 4.28, min: 3.59, max: 4.65)),
        NamedSpread(name: "Gracile+Lit", spread: Spread(median: 4.65, min: 3.92, max: 5.07)),
        NamedSpread(name: "Angular", spread: Spread(median: 4.97, min: 3.19, max: 6.82)),
    ]
}
