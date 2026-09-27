import SwiftUI
import UIKit

@main
struct QuitSmokingDurationApp: App {
    init() {
        UIScrollView.appearance().bounces = false

        let navy = UIColor(red: 0.055, green: 0.09, blue: 0.18, alpha: 1)
        let coral = UIColor(red: 0.96, green: 0.31, blue: 0.22, alpha: 1)
        let warmWhite = UIColor(red: 0.965, green: 0.95, blue: 0.91, alpha: 1)

        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = navy
        tabBarAppearance.shadowColor = .clear
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.white.withAlphaComponent(0.48)
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.white.withAlphaComponent(0.48)
        ]
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = coral
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: coral,
            .font: UIFont.systemFont(ofSize: 10, weight: .bold)
        ]
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance

        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.configureWithOpaqueBackground()
        navigationAppearance.backgroundColor = warmWhite
        navigationAppearance.shadowColor = .clear
        navigationAppearance.largeTitleTextAttributes = [
            .foregroundColor: navy,
            .font: UIFont.systemFont(ofSize: 34, weight: .black)
        ]
        navigationAppearance.titleTextAttributes = [
            .foregroundColor: navy,
            .font: UIFont.systemFont(ofSize: 17, weight: .bold)
        ]
        UINavigationBar.appearance().standardAppearance = navigationAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

