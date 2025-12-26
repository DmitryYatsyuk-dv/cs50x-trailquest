//
// VisitedCheckpointRecord.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import Foundation

enum TQSource: String, Codable, CaseIterable {
    case manual
    case qr
    case beacon
}

struct VisitedCheckpointRecord: Identifiable, Equatable, Codable {
    let id: UUID
    let checkpointID: Int
    let sequenceNumber: Int
    let visitedAt: Date
    let latitude: Double
    let longitude: Double
    let checkpointName: String
    let source: TQSource

    init(
        id: UUID = UUID(),
        checkpointID: Int,
        sequenceNumber: Int,
        visitedAt: Date,
        latitude: Double,
        longitude: Double,
        checkpointName: String,
        source: TQSource
    ) {
        self.id = id
        self.checkpointID = checkpointID
        self.sequenceNumber = sequenceNumber
        self.visitedAt = visitedAt
        self.latitude = latitude
        self.longitude = longitude
        self.checkpointName = checkpointName
        self.source = source
    }
}
