//
// TQQRScannerView.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import AVFoundation
import Foundation
import SwiftUI

struct TQQRScannerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.palette) private var palette
    @StateObject private var viewModel = TQQRScannerViewModel()

    var onCodeDetected: (String) -> Void

    var body: some View {
        ZStack {
            TQCameraPreview(session: viewModel.session)
                .ignoresSafeArea()

            TQScannerOverlay()

            VStack {
                header
                Spacer()
                instruction
                if let code = viewModel.detectedCode {
                    resultView(code: code)
                        .onAppear {
                            onCodeDetected(code)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                dismiss()
                            }
                        }
                }
            }
            .padding()
        }
        .onAppear {
            viewModel.start()
        }
        .onDisappear {
            viewModel.stop()
        }
        .overlay(alignment: .bottom) {
            if let message = viewModel.bannerMessage {
                errorBanner(message: message)
                    .padding(.bottom, 32)
            }
        }
        .alert(L10n.Qr.Alert.title, isPresented: settingsAlertBinding) {
            Button(L10n.Common.settings) {
                viewModel.openSettings()
            }
            Button(L10n.Common.cancel, role: .cancel) {}
        } message: {
            Text(viewModel.settingsAlertMessage ?? L10n.Qr.Permission.defaultMessage)
        }
    }

    private var settingsAlertBinding: Binding<Bool> {
        Binding(
            get: { viewModel.shouldShowSettingsAlert },
            set: { isPresented in
                if !isPresented {
                    viewModel.acknowledgeSettingsAlert()
                }
            }
        )
    }

    private var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(palette.background.base.color.opacity(0.9))
                    .shadow(color: Color.black.opacity(0.25), radius: 4, y: 2)
            }
            Spacer()
            if viewModel.isScanning {
                Text(L10n.Qr.Banner.scanning)
                    .font(.subheadline)
                    .foregroundStyle(palette.background.base.color)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(palette.accent.primary.color.opacity(0.85))
                    )
            }
        }
        .padding(.top, 12)
    }

    private var instruction: some View {
        Text(L10n.Qr.instruction)
            .font(.headline)
            .foregroundStyle(palette.background.base.color)
            .multilineTextAlignment(.center)
            .padding(.bottom, 24)
            .shadow(color: Color.black.opacity(0.35), radius: 6, y: 3)
    }

    private func resultView(code: String) -> some View {
        VStack(spacing: 8) {
            Text(L10n.Qr.detected)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(palette.background.base.color)
            Text(code)
                .font(.footnote.monospaced())
                .foregroundStyle(palette.background.base.color.opacity(0.9))
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(palette.accent.primary.color.opacity(0.85))
        )
        .padding(.bottom, 48)
    }

    private func errorBanner(message: String) -> some View {
        Text(message)
            .font(.footnote)
            .foregroundStyle(palette.background.base.color)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(palette.utility.error.color.opacity(0.85))
            )
            .multilineTextAlignment(.center)
            .shadow(color: Color.black.opacity(0.25), radius: 6, y: 3)
    }
}

#Preview {
    TQQRScannerView { _ in }
        .environment(\.palette, TQPalette())
}
