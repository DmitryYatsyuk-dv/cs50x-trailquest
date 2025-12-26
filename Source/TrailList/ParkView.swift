//
// ParkView.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import SwiftUI

struct ParkView: View {
    @Environment(\.palette) private var palette

    let park: TQPark

    var body: some View {
        VStack(spacing: 0) {
            if !park.imageURL.isEmpty {
                Image(park.imageURL, bundle: TQBundleHelper.bundle)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .aspectRatio(16.0 / 9.0, contentMode: .fit)
                    .clipped()
            }

            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .firstTextBaseline) {
                    Text(park.name)
                        .font(.headline)
                        .foregroundStyle(palette.text.primary.color)

                    Spacer(minLength: 12)

                    HStack(spacing: 6) {
                        Image(systemName: "flag.fill")
                            .font(.subheadline)
                            .foregroundStyle(palette.text.secondary.color)

                        Text("\(park.checkpoints.count)")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(palette.text.primary.color)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule(style: .continuous)
                            .fill(palette.background.groupElement.color.opacity(0.85))
                    )
                }

                Text(park.description)
                    .font(.subheadline)
                    .foregroundStyle(palette.text.secondary.color)
                    .lineLimit(3)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(palette.background.card.color)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(palette.utility.border.color, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

#Preview {
    ParkView(
        park: TQPark(
            id: 1,
            name: "Парк тест",
            description: "Описание тестового парка",
            location: TQLocation(lat: 0, lng: 0),
            imageURL: "streshnevo",
            tags: [],
            checkpoints: []
        )
    )
    .environment(\.palette, TQPalette())
}
