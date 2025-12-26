//
// TQVisitedCheckpointPresentable.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import Foundation

struct TQVisitedCheckpointPresentable: Identifiable, Equatable, Hashable {
    let id: Int
    let sequenceNumber: Int
    let checkpointName: String
    let durationText: String

    init(sequenceNumber: Int, checkpointName: String, durationText: String) {
        self.id = sequenceNumber
        self.sequenceNumber = sequenceNumber
        self.checkpointName = checkpointName
        self.durationText = durationText
    }
}

