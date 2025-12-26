//
// OnboardingState.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import Foundation

@MainActor
final class OnboardingState: ObservableObject {
    @Published private(set) var isCompleted: Bool

    private let defaults: UserDefaults
    private let storageKey = "trailquest.onboarding.completed"

    init(defaults: UserDefaults = .standard, forceShow: Bool = false) {
        self.defaults = defaults
        if forceShow {
            defaults.removeObject(forKey: storageKey)
            self.isCompleted = false
        } else {
            self.isCompleted = defaults.bool(forKey: storageKey)
        }
    }

    var needsOnboarding: Bool {
        !isCompleted
    }

    func markCompleted() {
        guard !isCompleted else { return }
        isCompleted = true
        defaults.set(true, forKey: storageKey)
    }
}
