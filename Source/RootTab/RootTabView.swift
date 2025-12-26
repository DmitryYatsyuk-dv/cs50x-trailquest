//
// RootTabView.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import SwiftUI

struct RootTabView: View {
    @Environment(\.palette) private var palette
    @StateObject private var router = TQRouter()

    init() {}

    var body: some View {
        TabView() {
            TrailList()
                .environmentObject(router)
                .tabItem {
                    Label(L10n.Tab.routes, systemImage: "map")
                }

            TQHistoryList()
                .tabItem {
                    Label(L10n.Tab.history, systemImage: "clock")
                }

            TQProfileView()
                .tabItem {
                    Label(L10n.Tab.profile, systemImage: "person")
                }

        }
        .tint(palette.accent.primary.color)
        .background(palette.background.base.color)
    }
}

#Preview {
    RootTabView()
        .environment(\.palette, TQPalette())
}
