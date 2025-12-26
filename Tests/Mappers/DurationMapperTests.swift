//
// DurationMapperTests.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import XCTest
import Foundation
@testable import TrailQuest

final class DurationMapperTests: XCTestCase {

    func testZeroDurationReturnsDefaultValue() {
        let start = Date(timeIntervalSince1970: 1000)
        let finish = start

        let result = DurationMapper.makeDurationText(
            start: start,
            finish: finish
        )

        XCTAssertEqual(result, L10n.Duration.zeroLong)
    }

    func testNegativeDurationReturnsDefaultValue() {
        let start = Date(timeIntervalSince1970: 2000)
        let finish = Date(timeIntervalSince1970: 1000)

        let result = DurationMapper.makeDurationText(
            start: start,
            finish: finish
        )

        XCTAssertEqual(result, L10n.Duration.zeroLong)
    }

    func testPositiveDurationUsesFormatter() {
        let start = Date(timeIntervalSince1970: 0)
        let finish = Date(timeIntervalSince1970: 3661)

        let result = DurationMapper.makeDurationText(
            start: start,
            finish: finish
        )

        XCTAssertEqual(result, formattedInterval(3661))
    }

    private func formattedInterval(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [.pad]
        return formatter.string(from: interval) ?? L10n.Duration.zeroLong
    }
}
