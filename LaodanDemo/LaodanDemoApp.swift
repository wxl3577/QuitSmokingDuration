import SwiftUI
import UIKit

@main
struct QuitSmokingDurationApp: App {
    init() {
        UIScrollView.appearance().bounces = false

        let ink = UIColor(red: 0.18, green: 0.23, blue: 0.28, alpha: 1)
        let accent = UIColor(red: 0.22, green: 0.40, blue: 0.58, alpha: 1)
        let muted = UIColor(red: 0.40, green: 0.45, blue: 0.49, alpha: 1)
        let background = UIColor(red: 0.97, green: 0.975, blue: 0.97, alpha: 1)

        let tab = UITabBarAppearance()
        tab.configureWithOpaqueBackground()
        tab.backgroundColor = .white
        tab.shadowColor = UIColor.black.withAlphaComponent(0.04)
        for item in [tab.stackedLayoutAppearance, tab.inlineLayoutAppearance, tab.compactInlineLayoutAppearance] {
            item.normal.iconColor = muted
            item.normal.titleTextAttributes = [.foregroundColor: muted]
            item.selected.iconColor = accent
            item.selected.titleTextAttributes = [.foregroundColor: accent]
        }
        UITabBar.appearance().standardAppearance = tab
        UITabBar.appearance().scrollEdgeAppearance = tab
        UITabBar.appearance().tintColor = accent

        let navigation = UINavigationBarAppearance()
        navigation.configureWithOpaqueBackground()
        navigation.backgroundColor = background
        navigation.shadowColor = .clear
        navigation.titleTextAttributes = [
            .foregroundColor: ink,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        UINavigationBar.appearance().standardAppearance = navigation
        UINavigationBar.appearance().scrollEdgeAppearance = navigation
    }

    var body: some Scene {
        WindowGroup { ContentView() }
    }
}

