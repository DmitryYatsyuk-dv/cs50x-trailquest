//
// TQRouter.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import Combine
import Foundation

final class TQRouter: ObservableObject {
    enum Route: Hashable {
        case trailDetail(TQPark)
    }

    @Published var path: [Route] = []
    @Published var activePark: TQPark?

    func showTrailDetail(for park: TQPark) {
        DispatchQueue.main.async { [weak self] in
            self?.path.append(.trailDetail(park))
        }
    }

    func showTrailActive(for park: TQPark) {
        DispatchQueue.main.async { [weak self] in
            self?.activePark = park
        }
    }

    func clearStack() {
        DispatchQueue.main.async { [weak self] in
            self?.path.removeAll()
        }
    }

    func reset() {
        DispatchQueue.main.async { [weak self] in
            self?.path.removeAll()
            self?.activePark = nil
        }
    }
}
