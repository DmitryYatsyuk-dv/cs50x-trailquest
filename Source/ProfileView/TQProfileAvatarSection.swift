//
// TQProfileAvatarSection.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import SwiftUI
import UIKit

struct TQProfileAvatarSection: View {
    let palette: TQPalette
    let image: UIImage?
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(
                            AngularGradient(
                                colors: [
                                    palette.accent.primary.color.opacity(0.88),
                                    palette.accent.secondary.color.opacity(0.85),
                                    palette.accent.primary.color.opacity(0.9)
                                ],
                                center: .center
                            )
                        )
                        .frame(width: 140, height: 140)
                        .shadow(color: .black.opacity(0.2), radius: 18, y: 8)
                        .overlay {
                            Circle()
                                .stroke(palette.background.base.color.opacity(0.85), lineWidth: 2)
                        }

                    if let image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 140, height: 140)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 96, height: 96)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        palette.background.base.color.opacity(0.95),
                                        palette.background.base.color.opacity(0.75)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }
                }

                Text(L10n.Profile.Photo.update)
                    .font(.headline)
                    .foregroundStyle(palette.text.primary.color)

                Text(L10n.Profile.Photo.hint)
                    .font(.subheadline)
                    .foregroundStyle(palette.text.secondary.color)
                    .multilineTextAlignment(.center)
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(palette.background.card.color)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(palette.utility.border.color, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    TQProfileAvatarSection(
        palette: TQPalette(),
        image: nil,
        onTap: {}
    )
    .environment(\.palette, TQPalette())
}
