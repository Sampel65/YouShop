//
//  MainTabView.swift
//  YouShop
//
//  Created by Samson Oluwapelumi on 10/03/2025.
//
import SwiftUI

struct MainTabView: View {
    let selectedTab: Int
    @Environment(\.colorScheme) var colorScheme
    
    init(selectedTab: Int = 0) {
        self.selectedTab = selectedTab
        _currentTab = State(initialValue: selectedTab)
    }
    
    @State private var currentTab: Int
    
    var body: some View {
        TabView(selection: $currentTab) {
            NavigationStack {
                HomeView()
            }
                .tag(0)
                .tabItem {
                    Image(currentTab == 0 ? "home1" : "home2")
                }
            
            NavigationStack {
                NotificationsView()
            }
                .tag(1)
                .tabItem {
                    Image(currentTab == 1 ? "notification2" : "notification")
                }
            
            NavigationStack {
                OrdersView()
            }
                .tag(2)
                .tabItem {
                    Image(currentTab == 2 ? "saved2" : "saved")
                }
            
            NavigationStack {
                ProfileView()
            }
                .tag(3)
                .tabItem {
                    Image(currentTab == 3 ? "profile2" : "profile")
                }
        }
        .tint(Color(AppColor.primaryColor))
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.backgroundColor = UIColor(colorScheme == .dark ? Color(AppColor.blackBackgroundColor) : .white)
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("SwitchToTab"))) { notification in
            if let tabIndex = notification.userInfo?["tabIndex"] as? Int {
                currentTab = tabIndex
            }
        }
    }
}
