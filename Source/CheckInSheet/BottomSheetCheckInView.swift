//
// BottomSheetCheckInView.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import SwiftUI

enum CheckInAction: Hashable {
    case code
    case qr
    case ble
}

struct BottomSheetCheckInView: View {
    @Environment(\.palette) private var palette

    let trailPoint: TrailPoint

    let isDemoRoute: Bool
    @Binding var manualCode: String
    @Binding var isManualCodeInvalid: Bool
    let onClose: () -> Void
    let onSelect: (CheckInAction) -> Void
    let onRequestQRCode: () -> Void

    @FocusState private var isCodeFieldFocused: Bool
    @State private var isBLECheckInPresented = false

    init(
        trailPoint: TrailPoint,
        isDemoRoute: Bool = false,
        manualCode: Binding<String>,
        isManualCodeInvalid: Binding<Bool> = .constant(false),
        onClose: @escaping () -> Void,
        onSelect: @escaping (CheckInAction) -> Void,
        onRequestQRCode: @escaping () -> Void
    ) {
        self.trailPoint = trailPoint
        self.isDemoRoute = isDemoRoute
        self._manualCode = manualCode
        self._isManualCodeInvalid = isManualCodeInvalid
        self.onClose = onClose
        self.onSelect = onSelect
        self.onRequestQRCode = onRequestQRCode
    }

    var body: some View {
        VStack(spacing: 20) {
            topBar
                .padding(.horizontal, 20)
                .padding(.bottom, -20)

            VStack(alignment: .leading, spacing: 16) {
                Text(L10n.Checkin.Sheet.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(palette.text.secondary.color)

                manualCodeSection
                actionButtons
            }
            .padding(.horizontal, 20)
        }
        .sheet(isPresented: $isBLECheckInPresented) {
            BLECheckInView(beaconID: trailPoint.beaconID ?? "") {
                onSelect(.ble)
                isBLECheckInPresented = false
            }
            .environment(\.palette, palette)
        }
    }

    private var topBar: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text(displayTitle)
                    .font(.title2.bold())
                    .foregroundStyle(palette.text.primary.color)
            }

            Spacer()

            Button(action: onClose) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundStyle(palette.text.secondary.color)
                    .padding(4)
            }
            .accessibilityLabel(L10n.Common.close)
        }
    }

    private var manualCodeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(L10n.Checkin.Manual.title)
                .font(.headline)
                .foregroundStyle(palette.text.primary.color)
                .padding(.bottom, -5)

            HStack(spacing: 12) {

                TextField(L10n.Checkin.Manual.placeholder, text: $manualCode)
                    .keyboardType(.numberPad)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .onChange(of: manualCode) { _ in
                        if isManualCodeInvalid {
                            isManualCodeInvalid = false
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(palette.background.groupElement.color)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(
                                isManualCodeInvalid ?
                                    palette.utility.error.color :
                                    (
                                        isCodeFieldFocused ?
                                            palette.accent.primary.color :
                                            palette.utility.border.color
                                    ),
                                lineWidth: 1.2
                            )
                    )
                    .focused($isCodeFieldFocused)

                Button {
                    let trimmed = manualCode.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmed.isEmpty else { return }
                    manualCode = trimmed
                    onSelect(.code)
                    isCodeFieldFocused = false
                } label: {
                    Text(L10n.Common.ok)
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(palette.background.base.color)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(palette.accent.primary.color)
                        )
                }
            }

            if isManualCodeInvalid {
                Text(L10n.Checkin.Manual.invalid)
                    .font(.footnote)
                    .foregroundStyle(palette.utility.error.color)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }

    private var actionButtons: some View {
        VStack(spacing: 12) {
            actionButton(
                iconName: "qrcode.viewfinder",
                title: isDemoRoute ? L10n.Checkin.Qr.titleDemo : L10n.Checkin.Qr.title,
                subtitle: L10n.Checkin.Qr.subtitle,
                background: palette.accent.primary.color.opacity(0.12),
                foreground: palette.accent.primary.color,
                subtitleColor: palette.accent.primary.color.opacity(0.75)
            ) {
                if isDemoRoute {
                    onSelect(.qr)
                } else {
                    onRequestQRCode()
                }
            }

            actionButton(
                iconName: "dot.radiowaves.left.and.right",
                title: isDemoRoute ? L10n.Checkin.Ble.titleDemo : L10n.Checkin.Ble.title,
                subtitle: L10n.Checkin.Ble.subtitle,
                background: palette.accent.tertiary.color.opacity(0.12),
                foreground: palette.accent.tertiary.color,
                subtitleColor: palette.accent.tertiary.color.opacity(0.75)
            ) {
                if isDemoRoute {
                    onSelect(.ble)
                } else {
                    isBLECheckInPresented = true
                }
            }

            if isDemoRoute {
                Text(L10n.Checkin.Demo.note)
                    .font(.footnote)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(2)
                    .foregroundStyle(palette.text.secondary.color)
                    .padding(.top, 4)
                    .padding(.horizontal, 4)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func actionButton(
        iconName: String,
        title: String,
        subtitle: String,
        background: Color,
        foreground: Color,
        subtitleColor: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: iconName)
                    .font(.system(size: 22, weight: .semibold))
                    .frame(width: 32, height: 32)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                    Text(subtitle)
                        .font(.footnote)
                        .foregroundStyle(subtitleColor)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(foreground)
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(background)
            )
        }
        .buttonStyle(.plain)
    }

    private var displayTitle: String {
        trailPoint.name
    }
}

#Preview {
    let samplePoint = TrailPoint(
        checkpointID: 1,
        sequenceNumber: 1,
        name: "Плотина бобров",
        coordinate: .init(latitude: 55.75, longitude: 37.61),
        beaconID: "BEACON-1",
        manualCode: "1284",
        qrCode: "SAMPLE-QR"
    )

    BottomSheetCheckInView(
        trailPoint: samplePoint,
        isDemoRoute: false,
        manualCode: .constant(""),
        isManualCodeInvalid: .constant(false),
        onClose: {},
        onSelect: { _ in },
        onRequestQRCode: {}
    )
    .environment(\.palette, TQPalette())
}
