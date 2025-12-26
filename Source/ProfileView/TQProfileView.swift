//
// TQProfileView.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import SwiftUI
import PhotosUI
import UIKit

enum TQProfileFocusField: Hashable {
    case name
}

struct TQProfileView: View {
    @Environment(\.palette) private var palette
    @Environment(\.competitionStore) private var competitionStore
    @StateObject private var viewModel = TQProfileViewModel()
    @FocusState private var focusedField: TQProfileFocusField?
    @State private var showImageSourceDialog = false
    @State private var isCameraPresented = false
    @State private var isPhotoPickerPresented = false
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var showCameraUnavailableAlert = false
    @State private var showSaveSuccess = false
    @State private var saveSuccessWorkItem: DispatchWorkItem?
    @State private var showDeleteConfirmation = false

    var body: some View {
        NavigationView {
            content
                .background(palette.background.base.color)
            .navigationTitle(L10n.Profile.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if viewModel.hasStoredProfile {
                        Menu {
                            Button(
                                role: .destructive,
                                action: { showDeleteConfirmation = true }
                            ) {
                                Label(L10n.Profile.delete, systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .imageScale(.large)
                        }
                    }
                }
            }
        }
        .profileDialogs(
            viewModel: viewModel,
            showImageSourceDialog: $showImageSourceDialog,
            isCameraPresented: $isCameraPresented,
            isPhotoPickerPresented: $isPhotoPickerPresented,
            selectedPhotoItem: $selectedPhotoItem,
            showCameraUnavailableAlert: $showCameraUnavailableAlert,
            showDeleteConfirmation: $showDeleteConfirmation,
            presentCamera: presentCamera,
            onDeleteConfirmed: performProfileReset
        )
        .onChange(of: selectedPhotoItem) { newItem in
            guard let newItem else { return }
            Task {
                await viewModel.handlePhotoPickerItem(newItem)
                await MainActor.run {
                    selectedPhotoItem = nil
                }
            }
        }
        .onChange(of: viewModel.saveCompleted) { isCompleted in
            guard isCompleted else { return }
            viewModel.acknowledgeSaveCompletion()
            triggerSaveSuccessFeedback()
        }
        .onAppear {
            focusNameFieldIfNeeded()
        }
        .onChange(of: viewModel.shouldFocusNameField) { _ in
            focusNameFieldIfNeeded()
        }
        .task {
            viewModel.configure(with: competitionStore)
        }
        .onDisappear {
            cancelSaveSuccessFeedback()
        }
    }

    private var isPrimaryActionDisabled: Bool {
        viewModel.isSaving || !hasValidName || !viewModel.hasUnsavedChanges
    }

    private var hasValidName: Bool {
        !viewModel.profile.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func avatarTapped() {
        focusedField = nil
        showImageSourceDialog = true
    }

    private func handleSave() {
        guard !isPrimaryActionDisabled else { return }
        focusedField = nil
        viewModel.saveProfile()
    }

    private func performProfileReset() {
        focusedField = nil
        Task {
            await viewModel.resetProfile()
        }
    }

    private func presentCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showCameraUnavailableAlert = true
            return
        }
        isCameraPresented = true
    }

    private func focusNameFieldIfNeeded() {
        guard viewModel.shouldFocusNameField else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
            if viewModel.shouldFocusNameField {
                focusedField = .name
            }
        }
    }

    private func triggerSaveSuccessFeedback() {
        saveSuccessWorkItem?.cancel()

        withAnimation(.spring(response: 0.45, dampingFraction: 0.75, blendDuration: 0.2)) {
            showSaveSuccess = true
        }

        let workItem = DispatchWorkItem {
            withAnimation(.easeOut(duration: 0.3)) {
                showSaveSuccess = false
            }
            saveSuccessWorkItem = nil
        }
        saveSuccessWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4, execute: workItem)
    }

    private func cancelSaveSuccessFeedback() {
        saveSuccessWorkItem?.cancel()
        saveSuccessWorkItem = nil
        showSaveSuccess = false
    }

    @ViewBuilder
    private var content: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 24) {
                    TQProfileAvatarSection(
                        palette: palette,
                        image: viewModel.profileImage,
                        onTap: avatarTapped
                    )

                    TQProfileFormSection(
                        palette: palette,
                        name: Binding(
                            get: { viewModel.profile.name },
                            set: { viewModel.updateName($0) }
                        ),
                        focusedField: $focusedField
                    )
                }
                .padding(.horizontal, 20)
            }

            VStack {
                Spacer()

                playButton
                    .padding(.horizontal, 20)
                    .padding(.bottom, 28)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)

            TQProfileSaveSuccessOverlay(
                show: $showSaveSuccess,
                palette: palette
            )
        }
    }

    private var playButton: some View {
        Button(action: handleSave) {
            Text(L10n.Profile.save)
                .font(.headline.bold())
                .foregroundColor(palette.background.base.color)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(palette.accent.primary.color)
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 20,
                        style: .continuous
                    )
                )
                .shadow(
                    color: palette.accent.primary.color.opacity(0.4),
                    radius: 10,
                    y: 4
                )
        }
        .buttonStyle(.plain)
        .disabled(isPrimaryActionDisabled)
        .opacity(isPrimaryActionDisabled ? 0.6 : 1.0)
    }
}


#Preview {
    TQProfileView()
        .environment(\.palette, TQPalette())
}
