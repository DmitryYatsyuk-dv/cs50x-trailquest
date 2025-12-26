//
// TQParksServiceError.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import Foundation

enum TQParksServiceError: LocalizedError {
    case fileNotFound
    case dataLoadingFailed(Error)
    case decodingFailed(Error)

    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "parks.json was not found in the expected bundle."
        case .dataLoadingFailed(let error):
            return "Failed to load parks.json: \(error.localizedDescription)"
        case .decodingFailed(let error):
            return "Failed to decode parks.json: \(error.localizedDescription)"
        }
    }
}

