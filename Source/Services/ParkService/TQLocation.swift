//
// TQLocation.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

import Foundation

struct TQLocation: Codable, Hashable {
    let lat: Double
    let lng: Double
}

typealias Location = TQLocation
