//
// CompetitionSummaryViewModel.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import Foundation
import Combine

final class CompetitionSummaryViewModel: ObservableObject {
    let summary: TQCompetitionRecordPresentable

    init(summary: TQCompetitionRecordPresentable) {
        self.summary = summary
    }
}

