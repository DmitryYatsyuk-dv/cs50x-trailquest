//
// TQParksServiceProtocol.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

protocol TQParksServiceProtocol {
    func getParks() async -> TQState<[TQPark]>
}

