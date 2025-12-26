//
// TQProfileStorage.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import Foundation
import UIKit

struct TQProfileData: Codable, Sendable {
    var name: String
    var imageData: Data?

    static let empty = TQProfileData(name: "", imageData: nil)
}

protocol TQProfileStoring {
    func loadProfile() -> TQProfileData
    func saveProfile(_ profile: TQProfileData)
    func clearProfile()
    func hasStoredProfile() -> Bool
}

final class TQProfileStorage: TQProfileStoring {
    private enum Keys {
        static let profile = "trailquest.profile.data"
    }

    private let defaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.defaults = userDefaults
    }

    func loadProfile() -> TQProfileData {
        guard
            let data = defaults.data(forKey: Keys.profile),
            let profile = try? JSONDecoder().decode(TQProfileData.self, from: data)
        else {
            return .empty
        }
        return profile
    }

    func saveProfile(_ profile: TQProfileData) {
        guard let data = try? JSONEncoder().encode(profile) else {
            return
        }
        defaults.set(data, forKey: Keys.profile)
    }

    func clearProfile() {
        defaults.removeObject(forKey: Keys.profile)
    }

    func hasStoredProfile() -> Bool {
        defaults.data(forKey: Keys.profile) != nil
    }
}
