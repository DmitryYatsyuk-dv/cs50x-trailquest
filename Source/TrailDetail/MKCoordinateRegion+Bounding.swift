//
// MKCoordinateRegion+Bounding.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import MapKit

extension MKCoordinateRegion {
    static func boundingRegion(
        for coordinates: [CLLocationCoordinate2D],
        padding: CLLocationDegrees = 0.002
    ) -> MKCoordinateRegion {
        guard let first = coordinates.first else {
            return MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6176),
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
        }

        var minLat = first.latitude
        var maxLat = first.latitude
        var minLng = first.longitude
        var maxLng = first.longitude

        for coordinate in coordinates {
            minLat = Swift.min(minLat, coordinate.latitude)
            maxLat = Swift.max(maxLat, coordinate.latitude)
            minLng = Swift.min(minLng, coordinate.longitude)
            maxLng = Swift.max(maxLng, coordinate.longitude)
        }

        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLng + maxLng) / 2
        )

        let span = MKCoordinateSpan(
            latitudeDelta: max((maxLat - minLat) + padding, 0.005),
            longitudeDelta: max((maxLng - minLng) + padding, 0.005)
        )

        return MKCoordinateRegion(center: center, span: span)
    }
}
