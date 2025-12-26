//
// TrailList.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import SwiftUI

struct TrailList: View {
    @Environment(\.palette) private var palette
    @EnvironmentObject private var router: TQRouter
    @StateObject private var viewModel: TrailListViewModel

    init(viewModel: TrailListViewModel = TrailListViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack(path: $router.path) {
            content
                .navigationTitle(L10n.TrailList.title)
                .navigationDestination(for: TQRouter.Route.self) { route in
                    switch route {
                    case .trailDetail(let park):
                        TrailDetailView(park: park)
                            .environmentObject(router)
                    }
                }
        }
        .fullScreenCover(item: $router.activePark) { park in
            TrailActiveView(
                trailName: park.name,
                parkID: park.id,
                points: TrailDetailViewModel.makePoints(for: park),
                onPresented: {
                    router.clearStack()
                },
                onSummaryDismiss: {
                    router.reset()
                }
            )
        }
        .tint(palette.accent.primary.color)
        .background(palette.background.base.color)
        .onAppear {
            viewModel.onAppear()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            loadingView
        case .failure:
            failureView
        case .result(let parks):
            listView(for: parks)
        }
    }

    private var loadingView: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(palette.background.base.color)
    }

    private var failureView: some View {
        Text(L10n.TrailList.failure)
            .foregroundStyle(palette.text.primary.color)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(palette.background.base.color)
    }

    private func listView(for parks: [TQPark]) -> some View {
        List {
            ForEach(parks) { park in
                Button {
                    router.showTrailDetail(for: park)
                } label: {
                    ParkView(park: park)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
                .listRowBackground(palette.background.base.color)
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(palette.background.base.color)
    }
}

#Preview {
    struct PreviewService: TQParksServiceProtocol {
        func getParks() async -> TQState<[TQPark]> {
            .result([
                TQPark(
                    id: 1,
                    name: "Preview Park",
                    description: "Описание парка в превью.",
                    location: TQLocation(lat: 0, lng: 0),
                    imageURL: "",
                    tags: [],
                    checkpoints: []
                )
            ])
        }
    }

    return TrailList(
        viewModel: TrailListViewModel(service: PreviewService())
    )
    .environment(\.palette, TQPalette())
    .environmentObject(TQRouter())
}
