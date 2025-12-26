//
// TQProfileViewModel.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import Combine
import SwiftUI
import PhotosUI

@MainActor
final class TQProfileViewModel: ObservableObject {
    @Published var profile: TQProfileData
    @Published var profileImage: UIImage?
    @Published var isSaving: Bool = false
    @Published var saveCompleted: Bool = false
    @Published var hasStoredProfile: Bool
    @Published var hasUnsavedChanges: Bool = false
    @Published var shouldFocusNameField: Bool

    private let storage: TQProfileStoring
    private var competitionStore: CompetitionStore?

    init(storage: TQProfileStoring = TQProfileStorage()) {
        self.storage = storage
        let storedProfile = storage.loadProfile()
        self.profile = storedProfile
        if let imageData = storedProfile.imageData {
            self.profileImage = UIImage(data: imageData)
        }
        let storedFlag = storage.hasStoredProfile() && !storedProfile.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        self.hasStoredProfile = storedFlag
        self.hasUnsavedChanges = false
        self.shouldFocusNameField = !storedFlag
    }

    func configure(with store: CompetitionStore) {
        competitionStore = store
    }

    func updateName(_ name: String) {
        guard profile.name != name else { return }
        profile.name = name
        markUnsavedChanges()
    }

    func setProfileImage(_ image: UIImage?) {
        let newData = image?.jpegData(compressionQuality: 0.85)
        guard profile.imageData != newData else { return }
        profileImage = image
        profile.imageData = newData
        markUnsavedChanges()
    }

    func handlePhotoPickerItem(_ item: PhotosPickerItem?) async {
        guard let item else { return }
        if let data = try? await item.loadTransferable(type: Data.self),
           let image = UIImage(data: data) {
            await MainActor.run {
                setProfileImage(image)
            }
        }
    }

    func saveProfile() {
        isSaving = true
        saveCompleted = false
        storage.saveProfile(profile)
        isSaving = false
        saveCompleted = true
        hasStoredProfile = true
        hasUnsavedChanges = false
        shouldFocusNameField = false
    }

    func acknowledgeSaveCompletion() {
        saveCompleted = false
    }

    func resetProfile() async {
        if let competitionStore {
            do {
                try await competitionStore.deleteAll()
            } catch {
                assertionFailure("Failed to delete competition records: \(error)")
            }
        }

        storage.clearProfile()
        profile = .empty
        profileImage = nil
        hasStoredProfile = false
        hasUnsavedChanges = false
        saveCompleted = false
        isSaving = false
        shouldFocusNameField = true
    }

    private func markUnsavedChanges() {
        hasUnsavedChanges = true
        shouldFocusNameField = false
    }
}
