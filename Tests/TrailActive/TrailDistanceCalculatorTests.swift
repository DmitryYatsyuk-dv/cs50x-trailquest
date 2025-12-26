//
// TrailDistanceCalculatorTests.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import XCTest
import CoreLocation
@testable import TrailQuest

final class TrailDistanceCalculatorTests: XCTestCase {

    func testTotalDistanceSumsAllSegments() {
        let coordinates = [
            CLLocationCoordinate2D(latitude: 0, longitude: 0),
            CLLocationCoordinate2D(latitude: 0, longitude: 1),
            CLLocationCoordinate2D(latitude: 1, longitude: 1)
        ]

        let first = CLLocation(latitude: 0, longitude: 0)
        let second = CLLocation(latitude: 0, longitude: 1)
        let third = CLLocation(latitude: 1, longitude: 1)
        let expected = first.distance(from: second) + second.distance(from: third)

        let result = TrailDistanceCalculator.totalDistance(for: coordinates)

        XCTAssertEqual(result, expected, accuracy: 0.1)
    }

    func testDistanceCoveredUsesVisitedCount() {
        let coordinates = [
            CLLocationCoordinate2D(latitude: 0, longitude: 0),
            CLLocationCoordinate2D(latitude: 0, longitude: 1),
            CLLocationCoordinate2D(latitude: 1, longitude: 1)
        ]

        let first = CLLocation(latitude: 0, longitude: 0)
        let second = CLLocation(latitude: 0, longitude: 1)
        let expected = first.distance(from: second)

        let result = TrailDistanceCalculator.distanceCovered(
            visitedCount: 2,
            coordinates: coordinates
        )

        XCTAssertEqual(result, expected, accuracy: 0.1)
    }

    func testDistanceCoveredForZeroOrOnePointIsZero() {
        let coordinates = [
            CLLocationCoordinate2D(latitude: 0, longitude: 0),
            CLLocationCoordinate2D(latitude: 0, longitude: 1)
        ]

        XCTAssertEqual(
            TrailDistanceCalculator.distanceCovered(
                visitedCount: 0,
                coordinates: coordinates
            ), 0
        )
        XCTAssertEqual(
            TrailDistanceCalculator.distanceCovered(
                visitedCount: 1,
                coordinates: coordinates
            ), 0
        )
    }
}
