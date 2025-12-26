//
// BLECheckInView.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import SwiftUI
import UIKit

struct BLECheckInView: View {
    @Environment(\.palette) private var palette
    @Environment(\.dismiss) private var dismiss
    @StateObject private var manager = BLECheckInManager()

    @State private var showPermissionAlert = false

    let beaconID: String
    let onCheckIn: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Capsule()
                .fill(palette.background.group.color.opacity(0.6))
                .frame(width: 48, height: 5)
                .padding(.top, 12)

            Image(systemName: "dot.radiowaves.left.and.right")
                .font(.system(size: 48, weight: .semibold))
                .foregroundStyle(palette.accent.primary.color)
                .shadow(color: palette.accent.primary.color.opacity(0.3), radius: 12, y: 6)

            Text(L10n.Checkin.Ble.searchTitle)
                .font(.title2.weight(.semibold))
                .foregroundStyle(palette.text.primary.color)

            Text(L10n.Checkin.Ble.searchMessage)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(palette.text.secondary.color)
                .padding(.horizontal, 16)

            if let beacon = manager.nearbyBeaconID {
                VStack(spacing: 12) {
                    Text(L10n.Checkin.Ble.found)
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(palette.accent.tertiary.color)

                    Text(beacon.uuidString)
                        .font(.footnote.monospaced())
                        .foregroundStyle(palette.text.secondary.color)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)

                    Button {
                        manager.stop()
                        onCheckIn()
                        dismiss()
                    } label: {
                        Text(L10n.Checkin.Ble.confirm)
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(palette.background.base.color)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(palette.accent.primary.color)
                            )
                    }
                    .buttonStyle(.plain)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(palette.background.groupElement.color)
                        .shadow(color: palette.background.selection.color.opacity(0.25), radius: 10, y: 4)
                )
                .padding(.horizontal, 16)
            } else {
                VStack(spacing: 16) {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(palette.accent.primary.color)
                    Text(L10n.Checkin.Ble.searching)
                        .font(.footnote)
                        .foregroundStyle(palette.text.secondary.color)
                }
                .padding(.top, 8)
            }

            Spacer()
        }
        .padding(.bottom, 24)
        .background(palette.background.base.color.ignoresSafeArea())
        .onAppear {
            manager.startSearch(for: beaconID)
        }
        .onDisappear {
            manager.stop()
        }
        .onChange(of: manager.authorizationDenied) { denied in
            showPermissionAlert = denied
        }
        .alert(L10n.Checkin.Ble.alertTitle, isPresented: $showPermissionAlert) {
            Button(L10n.Common.settings) {
                manager.stop()
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }
            Button(L10n.Common.cancel, role: .cancel) {
                manager.stop()
                dismiss()
            }
        } message: {
            Text(L10n.Checkin.Ble.permissionMessage)
        }
    }
}

#Preview {
    BLECheckInView(beaconID: "BEACON-1", onCheckIn: {})
        .environment(\.palette, TQPalette())
}
