//
// DurationMapper.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import Foundation

enum DurationMapper {
    static func makeDurationText(start: Date, finish: Date) -> String {
        let interval = max(finish.timeIntervalSince(start), 0)
        if interval == 0 {
            return L10n.Duration.zeroLong
        }

        return durationFormatter.string(from: interval) ?? L10n.Duration.zeroLong
    }

    private static var durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad]
        return formatter
    }()
}
