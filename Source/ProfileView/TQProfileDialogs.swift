//
// TQProfileDialogs.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import PhotosUI
import SwiftUI

struct TQProfileDialogs: ViewModifier {
    @ObservedObject var viewModel: TQProfileViewModel
    @Binding var showImageSourceDialog: Bool
    @Binding var isCameraPresented: Bool
    @Binding var isPhotoPickerPresented: Bool
    @Binding var selectedPhotoItem: PhotosPickerItem?
    @Binding var showCameraUnavailableAlert: Bool
    @Binding var showDeleteConfirmation: Bool
    let presentCamera: () -> Void
    let onDeleteConfirmed: () -> Void

    func body(content: Content) -> some View {
        content
            .photosPicker(
                isPresented: $isPhotoPickerPresented,
                selection: $selectedPhotoItem,
                matching: .images
            )
            .sheet(isPresented: $isCameraPresented) {
                TQCameraCaptureView { image in
                    viewModel.setProfileImage(image)
                }
            }
            .confirmationDialog(
                L10n.Profile.Photo.updateTitle,
                isPresented: $showImageSourceDialog,
                titleVisibility: .visible
            ) {
                Button(L10n.Profile.Photo.take) {
                    presentCamera()
                }
                Button(L10n.Profile.Photo.pick) {
                    isPhotoPickerPresented = true
                }
                Button(L10n.Common.cancel, role: .cancel) {}
            }
            .alert(L10n.Profile.Camera.unavailableTitle, isPresented: $showCameraUnavailableAlert) {
                Button(L10n.Common.gotIt, role: .cancel) {}
            } message: {
                Text(L10n.Profile.Camera.unavailableMessage)
            }
            .confirmationDialog(
                L10n.Profile.Delete.confirmTitle,
                isPresented: $showDeleteConfirmation,
                titleVisibility: .visible
            ) {
                Button(L10n.Common.delete, role: .destructive) {
                    onDeleteConfirmed()
                }
                Button(L10n.Common.cancel, role: .cancel) {}
            } message: {
                Text(L10n.Profile.Delete.confirmMessage)
            }
    }
}

extension View {
    func profileDialogs(
        viewModel: TQProfileViewModel,
        showImageSourceDialog: Binding<Bool>,
        isCameraPresented: Binding<Bool>,
        isPhotoPickerPresented: Binding<Bool>,
        selectedPhotoItem: Binding<PhotosPickerItem?>,
        showCameraUnavailableAlert: Binding<Bool>,
        showDeleteConfirmation: Binding<Bool>,
        presentCamera: @escaping () -> Void,
        onDeleteConfirmed: @escaping () -> Void
    ) -> some View {
        modifier(
            TQProfileDialogs(
                viewModel: viewModel,
                showImageSourceDialog: showImageSourceDialog,
                isCameraPresented: isCameraPresented,
                isPhotoPickerPresented: isPhotoPickerPresented,
                selectedPhotoItem: selectedPhotoItem,
                showCameraUnavailableAlert: showCameraUnavailableAlert,
                showDeleteConfirmation: showDeleteConfirmation,
                presentCamera: presentCamera,
                onDeleteConfirmed: onDeleteConfirmed
            )
        )
    }
}
