//
// TrailQuestApp.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import SwiftUI
import TrailQuest

@main
struct TrailQuestApp: App {
    var body: some Scene {
        WindowGroup {
            MainViewFactory.createView()
        }
    }
}
