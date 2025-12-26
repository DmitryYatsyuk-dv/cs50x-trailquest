//
// TrailDetailView.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import MapKit
import SwiftUI

struct TrailDetailView: View {
    @Environment(\.palette) private var palette
    @EnvironmentObject private var router: TQRouter

    private let viewModel: TrailDetailViewModel

    @State private var region: MKCoordinateRegion

    init(park: TQPark) {
        let viewModel = TrailDetailViewModel(park: park)
        self.viewModel = viewModel
        let initialRegion = MKCoordinateRegion.boundingRegion(
            for: viewModel.points.map { $0.coordinate },
            padding: 0.01
        )
        _region = State(initialValue: initialRegion)
    }

    var body: some View {
        content
            .background(palette.background.base.color.ignoresSafeArea())
            .safeAreaInset(edge: .bottom) {
                playButton
                    .padding(.horizontal, 20)
                    .padding(.bottom, 28)
            }
    }

    private var content: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                mapSection
                detailsSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
        }
    }

    private var mapSection: some View {
        Map(
            coordinateRegion: $region,
            interactionModes: [],
            annotationItems: viewModel.points
        ) { point in
            annotation(for: point)
        }
        .aspectRatio(1, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(
                    LinearGradient(
                        colors: [
                            palette.accent.primary.color.opacity(0.6),
                            palette.accent.secondary.color.opacity(0.6)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
        .shadow(color: palette.background.base.color.opacity(0.25), radius: 8, y: 3)
    }

    private var playButton: some View {
        Button {
            router.showTrailActive(for: viewModel.park)
        } label: {
            Text(L10n.TrailDetail.start)
                .font(.headline.bold())
                .foregroundColor(palette.background.base.color)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(palette.accent.primary.color)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: palette.accent.primary.color.opacity(0.4), radius: 10, y: 4)
        }
        .buttonStyle(.plain)
    }

    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(viewModel.name)
                .font(.headline)
                .foregroundStyle(palette.text.primary.color)

            Text(viewModel.description)
                .font(.subheadline)
                .foregroundStyle(palette.text.secondary.color)

            HStack(spacing: 6) {
                Image(systemName: "flag.fill")
                    .font(.footnote.bold())
                    .foregroundStyle(palette.text.secondary.color)

                Text(viewModel.numberOfPoints)
                    .font(.footnote)
                    .foregroundStyle(palette.text.secondary.color)
            }
        }
    }

    private func annotation(for point: TrailPoint) -> some MapAnnotationProtocol {
        MapAnnotation(coordinate: point.coordinate) {
            VStack(spacing: 2) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    palette.accent.primary.color
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 24, height: 24)
                        .shadow(color: .black.opacity(0.2), radius: 2, y: 1)

                    Image(systemName: "flag.fill")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.white)
                }
                Rectangle()
                    .fill(palette.accent.primary.color)
                    .frame(width: 2, height: 6)
            }
        }
    }
}

#Preview {
    NavigationView {
        TrailDetailView(
            park: TQPark(
                id: 1,
                name: "Плотина бобров",
                description: "Маршрут вокруг живописной плотины бобров.",
                location: TQLocation(lat: 55.7558, lng: 37.6176),
                imageURL: "streshnevo",
                tags: ["Семейный"],
                checkpoints: [
                    TQCheckpoint(
                        id: 1,
                        sequenceNumber: 1,
                        name: "Старт",
                        location: TQLocation(lat: 55.7558, lng: 37.6176),
                        beaconID: "beacon_start",
                        manualCode: "1111",
                        qrCode: "STRESH-QR-1001"
                    ),
                    TQCheckpoint(
                        id: 2,
                        sequenceNumber: 2,
                        name: "Озеро",
                        location: TQLocation(lat: 55.7585, lng: 37.6250),
                        beaconID: "beacon_lake",
                        manualCode: "2222",
                        qrCode: "STRESH-QR-1002"
                    ),
                    TQCheckpoint(
                        id: 3,
                        sequenceNumber: 3,
                        name: "Финиш",
                        location: TQLocation(lat: 55.7510, lng: 37.6060),
                        beaconID: "beacon_finish",
                        manualCode: "3333",
                        qrCode: "STRESH-QR-1003"
                    )
                ]
            )
        )
        .environment(\.palette, TQPalette())
    }
    .environmentObject(TQRouter())
}
