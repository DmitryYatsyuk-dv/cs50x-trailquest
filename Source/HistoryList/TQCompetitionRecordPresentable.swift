//
// TQCompetitionRecordPresentable.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import Foundation

struct TQCompetitionRecordPresentable: Identifiable, Equatable, Hashable {
    let id: UUID
    let parkName: String
    let durationText: String
    let progressText: String
    let visitedCheckpoints: [TQVisitedCheckpointPresentable]

    init?(record: CompetitionRecord) {
        guard let finishDate = record.finishDate else { return nil }

        let checkpoints = record.visitedCheckpoints.sorted { $0.sequenceNumber < $1.sequenceNumber }

        self.id = record.id
        self.parkName = record.parkName
        self.durationText = DurationMapper.makeDurationText(start: record.startDate, finish: finishDate)
        self.progressText = L10n.History.progress(checkpoints.count, record.totalCheckpoints)
        self.visitedCheckpoints = checkpoints.map {
            TQVisitedCheckpointPresentable(
                sequenceNumber: $0.sequenceNumber,
                checkpointName: $0.checkpointName,
                durationText: DurationMapper.makeDurationText(start: record.startDate, finish: $0.visitedAt)
            )
        }
    }
}
