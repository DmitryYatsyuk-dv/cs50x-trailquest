//
// TrailDetailViewModel.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import CoreLocation
import Foundation

final class TrailDetailViewModel {
    let park: TQPark
    let name: String
    let description: String
    let parkID: Int
    let points: [TrailPoint]
    let numberOfPoints: String

    init(park: TQPark) {
        self.park = park
        name = park.name
        description = park.description
        parkID = park.id
        points = Self.makePoints(for: park)
        numberOfPoints = L10n.TrailDetail.pointsCount(points.count)
    }

    static func makePoints(for park: TQPark) -> [TrailPoint] {
        park.checkpoints
            .sorted { $0.sequenceNumber < $1.sequenceNumber }
            .map { checkpoint in
                TrailPoint(
                    checkpointID: checkpoint.id,
                    sequenceNumber: checkpoint.sequenceNumber,
                    name: checkpoint.name,
                    coordinate: CLLocationCoordinate2D(
                        latitude: checkpoint.location.lat,
                        longitude: checkpoint.location.lng
                    ),
                    beaconID: checkpoint.beaconID,
                    manualCode: checkpoint.manualCode,
                    qrCode: checkpoint.qrCode
                )
            }
    }
}
