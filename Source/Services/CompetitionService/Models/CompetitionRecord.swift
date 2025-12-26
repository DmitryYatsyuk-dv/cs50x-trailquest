//
// CompetitionRecord.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import Foundation

enum TQDifficulty: String, Codable, CaseIterable {
    case easy
    case medium
    case hard
}

struct CompetitionRecord: Identifiable, Equatable, Codable {
    let id: UUID
    let competitionUID: String
    let parkID: Int
    let parkName: String
    let startDate: Date
    let finishDate: Date?
    let totalCheckpoints: Int
    let visitedCheckpoints: [VisitedCheckpointRecord]
    let lastUpdatedAt: Date
    let progress: Double
    let difficulty: TQDifficulty

    init(
        id: UUID = UUID(),
        competitionUID: String,
        parkID: Int,
        parkName: String,
        startDate: Date,
        finishDate: Date?,
        totalCheckpoints: Int,
        visitedCheckpoints: [VisitedCheckpointRecord],
        lastUpdatedAt: Date,
        progress: Double,
        difficulty: TQDifficulty
    ) {
        self.id = id
        self.competitionUID = competitionUID
        self.parkID = parkID
        self.parkName = parkName
        self.startDate = startDate
        self.finishDate = finishDate
        self.totalCheckpoints = totalCheckpoints
        self.visitedCheckpoints = visitedCheckpoints.sorted { $0.sequenceNumber < $1.sequenceNumber }
        self.lastUpdatedAt = lastUpdatedAt
        self.progress = progress
        self.difficulty = difficulty
    }
}
