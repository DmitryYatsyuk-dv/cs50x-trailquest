//
// TQCheckpoint.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import Foundation

struct TQCheckpoint: Codable, Identifiable, Hashable {
    let id: Int
    let sequenceNumber: Int
    let name: String
    let location: TQLocation
    let beaconID: String
    let manualCode: String?
    let qrCode: String?

    enum CodingKeys: String, CodingKey {
        case id, name, location
        case sequenceNumber = "sequence_number"
        case beaconID = "beacon_id"
        case manualCode = "manual_code"
        case qrCode = "qr_code"
    }
}
