//
// TrailPoint.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import CoreLocation
import Foundation

struct TrailPoint: Identifiable {
    let id: UUID
    let checkpointID: Int?
    let sequenceNumber: Int?
    let name: String
    let coordinate: CLLocationCoordinate2D
    let beaconID: String?
    let manualCode: String?
    let qrCode: String?

    init(
        id: UUID = UUID(),
        checkpointID: Int? = nil,
        sequenceNumber: Int? = nil,
        name: String,
        coordinate: CLLocationCoordinate2D,
        beaconID: String? = nil,
        manualCode: String? = nil,
        qrCode: String? = nil
    ) {
        self.id = id
        self.checkpointID = checkpointID
        self.sequenceNumber = sequenceNumber
        self.name = name
        self.coordinate = coordinate
        self.beaconID = beaconID
        self.manualCode = manualCode
        self.qrCode = qrCode
    }
}
