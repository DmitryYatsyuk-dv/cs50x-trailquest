//
// TQColorPair.swift
// TrailQuest
//
// Created by Dmitry Yatsyuk
//

struct TQColorPair: Sendable {
    let light: UInt
    let dark: UInt

    init(light: UInt, dark: UInt) {
        self.light = light
        self.dark = dark
    }
}
