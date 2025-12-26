//
// TrailDistanceCalculator.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import CoreLocation

enum TrailDistanceCalculator {
    static func totalDistance(for coordinates: [CLLocationCoordinate2D]) -> Double {
        accumulatedDistance(upTo: coordinates.count, coordinates: coordinates)
    }

    static func distanceCovered(visitedCount: Int, coordinates: [CLLocationCoordinate2D]) -> Double {
        accumulatedDistance(upTo: visitedCount, coordinates: coordinates)
    }

    private static func accumulatedDistance(upTo count: Int, coordinates: [CLLocationCoordinate2D]) -> Double {
        guard count > 1 else { return 0 }
        
        let maxIndex = min(count, coordinates.count) - 1
        var total: Double = 0
        for index in 1...maxIndex {
            let start = CLLocation(latitude: coordinates[index - 1].latitude, longitude: coordinates[index - 1].longitude)
            let end = CLLocation(latitude: coordinates[index].latitude, longitude: coordinates[index].longitude)
            total += start.distance(from: end)
        }
        return total
    }
}
