import SwiftUI
import ArchitectureTokenBill

@main
struct DemoApp: App {
    // Launch arguments let the screenshot script open a specific screen:
    // -tab footprint|benchmark  -select <framework name>
    private let tab = TokenBillDemoView.Tab(rawValue: UserDefaults.standard.string(forKey: "tab") ?? "") ?? .footprint
    private let selected = UserDefaults.standard.string(forKey: "select")

    var body: some Scene {
        WindowGroup {
            TokenBillDemoView(tab: tab, selected: selected)
        }
    }
}
