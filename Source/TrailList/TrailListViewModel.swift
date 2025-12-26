//
// TrailListViewModel.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import Combine
import Foundation

final class TrailListViewModel: ObservableObject {
    @Published private(set) var state: TQState<[TQPark]> = .loading

    private let service: TQParksServiceProtocol
    private var isLoading = false
    private var hasLoaded = false

    init(service: TQParksServiceProtocol = TQParksService()) {
        self.service = service
    }

    func onAppear() {
        guard !isLoading else { return }
        guard !hasLoaded else { return }

        isLoading = true

        state = .loading

        Task { [weak self] in
            guard let self else { return }
            let result = await self.service.getParks()

            await MainActor.run {
                self.state = result
                self.isLoading = false
                if case .result = result {
                    self.hasLoaded = true
                }
            }
        }
    }
}
